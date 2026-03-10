// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatHistoryHash() => r'9a47ae349fba6a906426db272672de0b4940acdd';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [chatHistory].
@ProviderFor(chatHistory)
const chatHistoryProvider = ChatHistoryFamily();

/// See also [chatHistory].
class ChatHistoryFamily extends Family<AsyncValue<List<MessageResponse>>> {
  /// See also [chatHistory].
  const ChatHistoryFamily();

  /// See also [chatHistory].
  ChatHistoryProvider call(
    int bookingId,
  ) {
    return ChatHistoryProvider(
      bookingId,
    );
  }

  @override
  ChatHistoryProvider getProviderOverride(
    covariant ChatHistoryProvider provider,
  ) {
    return call(
      provider.bookingId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatHistoryProvider';
}

/// See also [chatHistory].
class ChatHistoryProvider
    extends AutoDisposeFutureProvider<List<MessageResponse>> {
  /// See also [chatHistory].
  ChatHistoryProvider(
    int bookingId,
  ) : this._internal(
          (ref) => chatHistory(
            ref as ChatHistoryRef,
            bookingId,
          ),
          from: chatHistoryProvider,
          name: r'chatHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatHistoryHash,
          dependencies: ChatHistoryFamily._dependencies,
          allTransitiveDependencies:
              ChatHistoryFamily._allTransitiveDependencies,
          bookingId: bookingId,
        );

  ChatHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
  }) : super.internal();

  final int bookingId;

  @override
  Override overrideWith(
    FutureOr<List<MessageResponse>> Function(ChatHistoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatHistoryProvider._internal(
        (ref) => create(ref as ChatHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingId: bookingId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MessageResponse>> createElement() {
    return _ChatHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatHistoryProvider && other.bookingId == bookingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatHistoryRef on AutoDisposeFutureProviderRef<List<MessageResponse>> {
  /// The parameter `bookingId` of this provider.
  int get bookingId;
}

class _ChatHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<MessageResponse>>
    with ChatHistoryRef {
  _ChatHistoryProviderElement(super.provider);

  @override
  int get bookingId => (origin as ChatHistoryProvider).bookingId;
}

String _$chatMessagesHash() => r'de784438e3d7c628729a32ef5e963676069c82d1';

/// See also [ChatMessages].
@ProviderFor(ChatMessages)
final chatMessagesProvider =
    AutoDisposeNotifierProvider<ChatMessages, List<MessageResponse>>.internal(
  ChatMessages.new,
  name: r'chatMessagesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatMessagesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatMessages = AutoDisposeNotifier<List<MessageResponse>>;
String _$signalRHubHash() => r'007160e612709fee1caab1c230c3934f8c4e890e';

/// See also [SignalRHub].
@ProviderFor(SignalRHub)
final signalRHubProvider = AutoDisposeNotifierProvider<SignalRHub,
    AsyncValue<HubConnectionState>>.internal(
  SignalRHub.new,
  name: r'signalRHubProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$signalRHubHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SignalRHub = AutoDisposeNotifier<AsyncValue<HubConnectionState>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
