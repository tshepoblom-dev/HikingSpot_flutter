// lib/features/notifications/data/models/notification_models.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

@freezed
class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required int id,
    required String title,
    required String messageText,
    required bool isRead,
    required DateTime createdAt,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) => _$NotificationItemFromJson(json);
}

// lib/features/ratings/data/models/rating_models.dart
