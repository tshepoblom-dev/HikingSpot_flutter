// lib/features/bookings/data/datasources/bookings_api_service.dart

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../models/booking_models.dart';

part 'bookings_api_service.g.dart';

@riverpod
BookingsApiService bookingsApiService(BookingsApiServiceRef ref) =>
    BookingsApiService(ref.watch(dioClientProvider));

class BookingsApiService {
  final Dio _dio;
  BookingsApiService(this._dio);

  Future<BookingResponse> requestBooking(BookingRequest request) async {
    try {
      final res = await _dio.post('/api/bookings/request', data: request.toJson());
      return BookingResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<BookingResponse> approveBooking(int bookingId) async {
    try {
      final res = await _dio.post('/api/bookings/approve', data: {'bookingId': bookingId});
      return BookingResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<BookingResponse> rejectBooking(int bookingId) async {
    try {
      final res = await _dio.post('/api/bookings/reject', data: {'bookingId': bookingId});
      return BookingResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<BookingResponse> cancelBooking(int bookingId) async {
    try {
      final res = await _dio.post('/api/bookings/cancel/$bookingId');
      return BookingResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<List<BookingResponse>> getMyBookings() async {
    try {
      final res = await _dio.get('/api/bookings/my');
      return (res.data as List).map((e) => BookingResponse.fromJson(e)).toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<List<BookingResponse>> getDriverBookings() async {
    try {
      final res = await _dio.get('/api/bookings/driver');
      return (res.data as List).map((e) => BookingResponse.fromJson(e)).toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
