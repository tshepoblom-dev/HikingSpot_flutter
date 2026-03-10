// lib/features/bookings/data/models/booking_models.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/mappers.dart';
import '../../../wallet/data/models/wallet_models.dart';

part 'booking_models.freezed.dart';
part 'booking_models.g.dart';

enum BookingStatus { pending, approved, rejected, cancelled }

@freezed
class BookingRequest with _$BookingRequest {
  const factory BookingRequest({
    required int tripId,
    @Default(1) int seatsRequested,
    @Default(0) int paymentMethod,   // 0=Cash, 1=Wallet, 2=PayShap
  }) = _BookingRequest;

  factory BookingRequest.fromJson(Map<String, dynamic> json) =>
      _$BookingRequestFromJson(json);
}

@freezed
class BookingResponse with _$BookingResponse {
  const factory BookingResponse({
    required int    bookingId,
    required int    tripId,
    @Default('') String passengerId,
    required String passengerName,
    required String departureCity,
    required String destinationCity,
    required DateTime departureTime,
    required int    seatsRequested,
    @BookingStatusConverter()
    required BookingStatus status,
    @Default(0) int paymentMethod,   // raw int from server
    @Default(false) bool commissionCharged,
    required DateTime requestedAt,
  }) = _BookingResponse;

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingResponseFromJson(json);
}

extension BookingResponseX on BookingResponse {
  PaymentMethod get paymentMethodEnum =>
      paymentMethodFromInt(paymentMethod);
}

@freezed
class BookingAction with _$BookingAction {
  const factory BookingAction({required int bookingId}) = _BookingAction;

  factory BookingAction.fromJson(Map<String, dynamic> json) =>
      _$BookingActionFromJson(json);
}
