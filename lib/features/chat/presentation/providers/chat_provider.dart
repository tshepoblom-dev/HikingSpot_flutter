// lib/features/chat/presentation/providers/chat_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/messages_api_service.dart';
import '../../data/models/message_models.dart';

part 'chat_provider.g.dart';

// ── Chat History ──────────────────────────────────────────────────────────────

@riverpod
Future<List<MessageResponse>> chatHistory(ChatHistoryRef ref, int bookingId) =>
    ref.read(messagesApiServiceProvider).getChatHistory(bookingId);

// ── Chat Messages (live, in-session) ─────────────────────────────────────────

@riverpod
class ChatMessages extends _$ChatMessages {
  @override
  List<MessageResponse> build() => [];

  void addMessage(MessageResponse msg) => state = [...state, msg];

  void setHistory(List<MessageResponse> msgs) => state = msgs;

  void clear() => state = [];
}

// ── SignalR Hub Manager ───────────────────────────────────────────────────────

@riverpod
class SignalRHub extends _$SignalRHub {
  HubConnection? _connection;
  int? _currentBookingId;

  @override
  AsyncValue<HubConnectionState> build() => const AsyncData(HubConnectionState.Disconnected);

  Future<void> connect(int bookingId) async {
    if (_currentBookingId == bookingId &&
        _connection?.state == HubConnectionState.Connected) return;

    await disconnect();
    _currentBookingId = bookingId;
    state = const AsyncLoading();

    try {
      final token = ref.read(authStateProvider).valueOrNull?.token ?? '';

      final logger = HubConnectionBuilder()
          .withUrl(
            '${AppConstants.hubUrl}?access_token=$token',
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token,
              transport: HttpTransportType.WebSockets,
            ),
          )
          .withAutomaticReconnect()
          .build();

      _connection = logger;

      // Listen for incoming messages
      _connection!.on('ReceiveMessage', (args) {
        if (args == null || args.isEmpty) return;
        try {
          final raw = args[0] as Map<String, dynamic>;
          final msg = MessageResponse.fromJson(raw);
          ref.read(chatMessagesProvider.notifier).addMessage(msg);
        } catch (_) {}
      });

      _connection!.onclose(({error}) {
        state = const AsyncData(HubConnectionState.Disconnected);
      });

      _connection!.onreconnecting(({error}) {
        state = const AsyncData(HubConnectionState.Reconnecting);
      });

      _connection!.onreconnected(({connectionId}) {
        state = const AsyncData(HubConnectionState.Connected);
        _rejoinGroup(bookingId);
      });

      await _connection!.start();
      await _rejoinGroup(bookingId);

      state = const AsyncData(HubConnectionState.Connected);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> _rejoinGroup(int bookingId) async {
    try {
      await _connection?.invoke('JoinBookingChat', args: [bookingId]);
    } catch (_) {}
  }

  Future<void> sendMessage(int bookingId, String text) async {
    if (_connection?.state != HubConnectionState.Connected) return;
    await _connection?.invoke('SendMessage', args: [bookingId, text]);
  }

  Future<void> disconnect() async {
    if (_currentBookingId != null) {
      try {
        await _connection?.invoke('LeaveBookingChat', args: [_currentBookingId as Object]);
      } catch (_) {}
    }
    await _connection?.stop();
    _connection = null;
    _currentBookingId = null;
    state = const AsyncData(HubConnectionState.Disconnected);
  }

  //@override
  void dispose() {
    disconnect();
    //super.dispose();
  }
}
