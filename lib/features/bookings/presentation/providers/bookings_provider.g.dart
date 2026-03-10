// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myBookingsHash() => r'4b835e0a4d96436fd503109a2818e48225f2886c';

/// See also [MyBookings].
@ProviderFor(MyBookings)
final myBookingsProvider = AutoDisposeAsyncNotifierProvider<MyBookings,
    List<BookingResponse>>.internal(
  MyBookings.new,
  name: r'myBookingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyBookings = AutoDisposeAsyncNotifier<List<BookingResponse>>;
String _$driverBookingsHash() => r'7be7430fbc18a6825881b2b076c4477a4c072d84';

/// See also [DriverBookings].
@ProviderFor(DriverBookings)
final driverBookingsProvider = AutoDisposeAsyncNotifierProvider<DriverBookings,
    List<BookingResponse>>.internal(
  DriverBookings.new,
  name: r'driverBookingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$driverBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DriverBookings = AutoDisposeAsyncNotifier<List<BookingResponse>>;
String _$requestBookingVMHash() => r'07748a0f96f632ad00f513f3f21fb65a910a076e';

/// See also [RequestBookingVM].
@ProviderFor(RequestBookingVM)
final requestBookingVMProvider = AutoDisposeNotifierProvider<RequestBookingVM,
    AsyncValue<BookingResponse?>>.internal(
  RequestBookingVM.new,
  name: r'requestBookingVMProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$requestBookingVMHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RequestBookingVM = AutoDisposeNotifier<AsyncValue<BookingResponse?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
