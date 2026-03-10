// lib/features/ride_requests/data/models/ride_request_models.dart

enum RideRequestStatus { open, driverOffered, accepted, completed, cancelled, expired }

extension RideRequestStatusX on RideRequestStatus {
  String get label {
    switch (this) {
      case RideRequestStatus.open:          return 'Open';
      case RideRequestStatus.driverOffered: return 'Offer Received';
      case RideRequestStatus.accepted:      return 'Accepted';
      case RideRequestStatus.completed:     return 'Completed';
      case RideRequestStatus.cancelled:     return 'Cancelled';
      case RideRequestStatus.expired:       return 'Expired';
    }
  }

  static RideRequestStatus fromString(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'open':          return RideRequestStatus.open;
      case 'driveroffered': return RideRequestStatus.driverOffered;
      case 'accepted':      return RideRequestStatus.accepted;
      case 'completed':     return RideRequestStatus.completed;
      case 'cancelled':     return RideRequestStatus.cancelled;
      case 'expired':       return RideRequestStatus.expired;
      default:              return RideRequestStatus.open;
    }
  }
}

// ── Ride Request Response ─────────────────────────────────────────────────────

class RideRequestResponse {
  final int id;
  final String passengerId;
  final String passengerName;
  final double passengerRating;
  final String fromCity;
  final String toCity;
  final DateTime requestedDate;
  final int seatsNeeded;
  final double? maxPrice;
  final String? notes;
  final RideRequestStatus status;
  final DateTime createdAt;

  // Set when a driver makes an offer
  final int? offeredTripId;
  final String? driverName;
  final String? driverId;
  final String? driverVehicle;
  final double? offeredPrice;
  final DateTime? offeredDepartureTime;

  const RideRequestResponse({
    required this.id,
    required this.passengerId,
    required this.passengerName,
    required this.passengerRating,
    required this.fromCity,
    required this.toCity,
    required this.requestedDate,
    required this.seatsNeeded,
    this.maxPrice,
    this.notes,
    required this.status,
    required this.createdAt,
    this.offeredTripId,
    this.driverName,
    this.driverId,
    this.driverVehicle,
    this.offeredPrice,
    this.offeredDepartureTime,
  });

  factory RideRequestResponse.fromJson(Map<String, dynamic> json) {
    return RideRequestResponse(
      id:                  (json['id'] as num).toInt(),
      passengerId:         json['passengerId'] as String,
      passengerName:       json['passengerName'] as String,
      passengerRating:     (json['passengerRating'] as num?)?.toDouble() ?? 0.0,
      fromCity:            json['fromCity'] as String,
      toCity:              json['toCity'] as String,
      requestedDate:       DateTime.parse(json['requestedDate'] as String),
      seatsNeeded:         (json['seatsNeeded'] as num).toInt(),
      maxPrice:            (json['maxPrice'] as num?)?.toDouble(),
      notes:               json['notes'] as String?,
      status:              RideRequestStatusX.fromString(json['status'] as String?),
      createdAt:           DateTime.parse(json['createdAt'] as String),
      offeredTripId:       (json['offeredTripId'] as num?)?.toInt(),
      driverName:          json['driverName'] as String?,
      driverId:            json['driverId'] as String?,
      driverVehicle:       json['driverVehicle'] as String?,
      offeredPrice:        (json['offeredPrice'] as num?)?.toDouble(),
      offeredDepartureTime: json['offeredDepartureTime'] != null
          ? DateTime.parse(json['offeredDepartureTime'] as String)
          : null,
    );
  }

  RideRequestResponse copyWith({
    RideRequestStatus? status,
    String? driverName,
    String? driverId,
    String? driverVehicle,
    double? offeredPrice,
    int? offeredTripId,
    DateTime? offeredDepartureTime,
  }) =>
      RideRequestResponse(
        id:                  id,
        passengerId:         passengerId,
        passengerName:       passengerName,
        passengerRating:     passengerRating,
        fromCity:            fromCity,
        toCity:              toCity,
        requestedDate:       requestedDate,
        seatsNeeded:         seatsNeeded,
        maxPrice:            maxPrice,
        notes:               notes,
        status:              status              ?? this.status,
        createdAt:           createdAt,
        offeredTripId:       offeredTripId       ?? this.offeredTripId,
        driverName:          driverName          ?? this.driverName,
        driverId:            driverId            ?? this.driverId,
        driverVehicle:       driverVehicle       ?? this.driverVehicle,
        offeredPrice:        offeredPrice        ?? this.offeredPrice,
        offeredDepartureTime: offeredDepartureTime ?? this.offeredDepartureTime,
      );
}

// ── Create Request ────────────────────────────────────────────────────────────

class RideRequestCreateRequest {
  final String fromCity;
  final String toCity;
  final DateTime requestedDate;
  final int seatsNeeded;
  final double? maxPrice;
  final String? notes;

  const RideRequestCreateRequest({
    required this.fromCity,
    required this.toCity,
    required this.requestedDate,
    required this.seatsNeeded,
    this.maxPrice,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'fromCity':      fromCity,
    'toCity':        toCity,
    'requestedDate': requestedDate.toIso8601String(),
    'seatsNeeded':   seatsNeeded,
    if (maxPrice != null) 'maxPrice': maxPrice,
    if (notes   != null) 'notes':    notes,
  };
}

// ── Driver Offer Request ──────────────────────────────────────────────────────

class RideOfferRequest {
  final int rideRequestId;
  final int? tripId;
  final String? message;

  const RideOfferRequest({
    required this.rideRequestId,
    this.tripId,
    this.message,
  });

  Map<String, dynamic> toJson() => {
    'rideRequestId': rideRequestId,
    if (tripId  != null) 'tripId':  tripId,
    if (message != null) 'message': message,
  };
}

// ── Search Params ─────────────────────────────────────────────────────────────

class RideRequestSearchParams {
  final String fromCity;
  final String toCity;
  final DateTime? date;
  final int page;
  final int pageSize;

  const RideRequestSearchParams({
    this.fromCity = '',
    this.toCity = '',
    this.date,
    this.page = 1,
    this.pageSize = 20,
  });

  RideRequestSearchParams copyWith({
    String? fromCity,
    String? toCity,
    DateTime? date,
    int? page,
    int? pageSize,
  }) =>
      RideRequestSearchParams(
        fromCity: fromCity ?? this.fromCity,
        toCity:   toCity   ?? this.toCity,
        date:     date     ?? this.date,
        page:     page     ?? this.page,
        pageSize: pageSize ?? this.pageSize,
      );
}
