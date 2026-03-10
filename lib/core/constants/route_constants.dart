// lib/core/constants/route_constants.dart

class RouteConstants {
  RouteConstants._();

  static const String splash         = '/';
  static const String onboarding     = '/onboarding';
  static const String login          = '/login';
  static const String register       = '/register';
  static const String home           = '/home';
  static const String tripSearch     = '/trips/search';
  static const String tripResults    = '/trips/results';
  static const String tripDetails    = '/trips/:tripId';
  static const String createTrip     = '/trips/create';
  static const String myTrips        = '/trips/my';
  static const String bookingList    = '/bookings';
  static const String manageBookings = '/bookings/manage';
  static const String driverProfile  = '/driver/profile';
  static const String driverCreate   = '/driver/create';
  static const String chat           = '/chat/:bookingId';
  static const String notifications  = '/notifications';
  static const String profile        = '/profile';
  static const String driverPublic   = '/drivers/:driverId';

  // ── Ride Requests ─────────────────────────────────────────────────────────
  static const String rideRequests       = '/ride-requests';
  static const String createRideRequest  = '/ride-requests/create';
  static const String myRideRequests     = '/ride-requests/my';

  // ── Wallet ────────────────────────────────────────────────────────────────
  static const String wallet = '/wallet';

  // Named route helpers
  static String tripDetailsPath(int tripId)    => '/trips/$tripId';
  static String chatPath(int bookingId)        => '/chat/$bookingId';
  static String driverPublicPath(int driverId) => '/drivers/$driverId';
}
