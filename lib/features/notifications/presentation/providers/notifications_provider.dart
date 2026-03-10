// lib/features/notifications/presentation/providers/notifications_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/notifications_api_service.dart';
import '../../data/models/notification_models.dart';

part 'notifications_provider.g.dart';

@riverpod
class NotificationsVM extends _$NotificationsVM {
  @override
  Future<List<NotificationItem>> build() =>
      ref.read(notificationsApiServiceProvider).getNotifications();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(notificationsApiServiceProvider).getNotifications(),
    );
  }

  Future<void> markAsRead(int id) async {
    await ref.read(notificationsApiServiceProvider).markAsRead(id);
    // Server will also push UnreadCountChanged — badge updates via hub.
    state = state.whenData((list) =>
      list.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList(),
    );
  }

  Future<void> markAllAsRead() async {
    await ref.read(notificationsApiServiceProvider).markAllAsRead();
    // Server will also push UnreadCountChanged with 0 — badge updates via hub.
    state = state.whenData((list) =>
      list.map((n) => n.copyWith(isRead: true)).toList(),
    );
  }

  // ── Real-time mutation (called by AppHubService) ───────────────────────────

  /// Prepend a notification pushed via the ReceiveNotification hub event.
  /// Idempotent — skips if an item with the same id already exists.
  void prepend(NotificationItem item) {
    state = state.whenData((list) {
      if (list.any((n) => n.id == item.id)) return list;
      return [item, ...list];
    });
  }
}

@riverpod
Future<int> unreadNotificationCount(UnreadNotificationCountRef ref) =>
    ref.read(notificationsApiServiceProvider).getUnreadCount();
