// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unreadNotificationCountHash() =>
    r'91bc62ea37d68579f7b14760bcdd4fe8fd76d8b1';

/// See also [unreadNotificationCount].
@ProviderFor(unreadNotificationCount)
final unreadNotificationCountProvider = AutoDisposeFutureProvider<int>.internal(
  unreadNotificationCount,
  name: r'unreadNotificationCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadNotificationCountRef = AutoDisposeFutureProviderRef<int>;
String _$notificationsVMHash() => r'1d9ececebcc5bdbcf37c5fb4efe4162a8caf4e4f';

/// See also [NotificationsVM].
@ProviderFor(NotificationsVM)
final notificationsVMProvider = AutoDisposeAsyncNotifierProvider<
    NotificationsVM, List<NotificationItem>>.internal(
  NotificationsVM.new,
  name: r'notificationsVMProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsVMHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationsVM = AutoDisposeAsyncNotifier<List<NotificationItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
