// lib/core/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/route_constants.dart';
import '../../core/firebase/firebase_service.dart';
import '../../core/signalr/app_hub_service.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/bookings/presentation/screens/booking_list_screen.dart';
import '../../features/bookings/presentation/screens/manage_bookings_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/driver/presentation/screens/create_driver_profile_screen.dart';
import '../../features/driver/presentation/screens/driver_profile_screen.dart';
import '../../features/driver/presentation/screens/public_driver_profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/ride_requests/presentation/screens/create_ride_request_screen.dart';
import '../../features/ride_requests/presentation/screens/my_ride_requests_screen.dart';
import '../../features/ride_requests/presentation/screens/ride_requests_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/trips/presentation/screens/create_trip_screen.dart';
import '../../features/trips/presentation/screens/home_screen.dart';
import '../../features/trips/presentation/screens/my_trips_screen.dart';
import '../../features/trips/presentation/screens/trip_details_screen.dart';
import '../../features/trips/presentation/screens/trip_results_screen.dart';
import '../../features/trips/presentation/screens/trip_search_screen.dart';
import '../utils/mappers.dart';

part 'app_router.g.dart';

// ── Router refresh notifier ───────────────────────────────────────────────────

class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

// ── App Router ────────────────────────────────────────────────────────────────

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final notifier = _RouterRefreshNotifier();

  ref.listen<AsyncValue<AuthStateModel>>(
    authStateProvider,
    (_, __) => notifier.notify(),
  );

  // ── Firebase push notification deep-linking ───────────────────────────────
  ref.listen<NotificationPayload?>(
    notificationTapProvider,
    (_, payload) {
      if (payload == null) return;
      final auth = ref.read(authStateProvider).valueOrNull;
      if (auth == null || !auth.isAuthenticated) return;
      Future.microtask(() {
        final router = ref.read(appRouterProvider);
        _navigateFromPayload(router, payload);
        ref.read(notificationTapProvider.notifier).state = null;
      });
    },
  );

  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: RouteConstants.splash,
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authValue   = ref.read(authStateProvider);
      final isSplash    = state.matchedLocation == RouteConstants.splash;
      final isAuthRoute = state.matchedLocation == RouteConstants.login ||
                          state.matchedLocation == RouteConstants.register;

      if (authValue.isLoading) return isSplash ? null : RouteConstants.splash;

      final isAuthenticated = authValue.valueOrNull?.isAuthenticated ?? false;

      if (isSplash) return isAuthenticated ? RouteConstants.home : RouteConstants.login;
      if (!isAuthenticated && !isAuthRoute) return RouteConstants.login;
      if (isAuthenticated  && isAuthRoute)  return RouteConstants.home;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: RouteConstants.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteConstants.tripSearch,
            builder: (_, __) => const TripSearchScreen(),
          ),
          GoRoute(
            path: RouteConstants.tripResults,
            builder: (_, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              return TripResultsScreen(searchParams: extra);
            },
          ),
          GoRoute(
            path: RouteConstants.tripDetails,
            builder: (_, state) {
              final tripId =
                  int.tryParse(state.pathParameters['tripId'] ?? '0') ?? 0;
              return TripDetailsScreen(tripId: tripId);
            },
          ),
          GoRoute(
            path: RouteConstants.createTrip,
            builder: (_, __) => const CreateTripScreen(),
          ),
          GoRoute(
            path: RouteConstants.myTrips,
            builder: (_, __) => const MyTripsScreen(),
          ),
          GoRoute(
            path: RouteConstants.bookingList,
            builder: (_, __) => const BookingListScreen(),
          ),
          GoRoute(
            path: RouteConstants.manageBookings,
            builder: (_, __) => const ManageBookingsScreen(),
          ),
          GoRoute(
            path: RouteConstants.driverProfile,
            builder: (_, __) => const DriverProfileScreen(),
          ),
          GoRoute(
            path: RouteConstants.driverCreate,
            builder: (_, __) => const CreateDriverProfileScreen(),
          ),
          GoRoute(
            path: RouteConstants.driverPublic,
            builder: (_, state) {
              final driverId =
                  int.tryParse(state.pathParameters['driverId'] ?? '0') ?? 0;
              return PublicDriverProfileScreen(driverProfileId: driverId);
            },
          ),
          GoRoute(
            path: RouteConstants.chat,
            builder: (_, state) {
              final bookingId =
                  int.tryParse(state.pathParameters['bookingId'] ?? '0') ?? 0;
              final extra = state.extra as Map<String, dynamic>? ?? {};
              return ChatScreen(
                  bookingId: bookingId,
                  tripTitle: extra['tripTitle'] ?? '');
            },
          ),
          GoRoute(
            path: RouteConstants.notifications,
            builder: (_, __) => const NotificationsScreen(),
          ),
          GoRoute(
            path: RouteConstants.rideRequests,
            builder: (_, __) => const RideRequestsScreen(),
          ),
          GoRoute(
            path: RouteConstants.createRideRequest,
            builder: (_, __) => const CreateRideRequestScreen(),
          ),
          GoRoute(
            path: RouteConstants.myRideRequests,
            builder: (_, __) => const MyRideRequestsScreen(),
          ),
          GoRoute(
            path: RouteConstants.wallet,
            builder: (_, __) => const WalletScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.error}')),
    ),
  );
}

// ── Firebase push notification → navigation ───────────────────────────────────

void _navigateFromPayload(GoRouter router, NotificationPayload payload) {
  switch (payload.type) {
    case 'booking':
      router.go(RouteConstants.bookingList);
      break;
    case 'booking_manage':
      router.go(RouteConstants.manageBookings);
      break;
    case 'chat':
      final id = int.tryParse(payload.id ?? '');
      if (id != null) {
        router.go(RouteConstants.chatPath(id));
      } else {
        router.go(RouteConstants.bookingList);
      }
      break;
    case 'ride_request':
    case 'ride_offer':
      router.go(RouteConstants.myRideRequests);
      break;
    case 'trip':
      final id = int.tryParse(payload.id ?? '');
      if (id != null) {
        router.go(RouteConstants.tripDetailsPath(id));
      } else {
        router.go(RouteConstants.home);
      }
      break;
    default:
      router.go(RouteConstants.notifications);
  }
}

// ── Bottom-nav shell ──────────────────────────────────────────────────────────

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = [
    RouteConstants.home,
    RouteConstants.tripSearch,
    RouteConstants.bookingList,
    RouteConstants.wallet,
    RouteConstants.notifications,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location    = GoRouterState.of(context).matchedLocation;
    // Badge driven by the hub's StateProvider — updates instantly on every
    // ReceiveNotification / UnreadCountChanged event, no polling needed.
    final unreadCount = ref.watch(unreadBadgeCountProvider);

    int currentIndex = 0;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) { currentIndex = i; break; }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Bookings',
          ),
          const NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text(unreadCount > 99 ? '99+' : '$unreadCount'),
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text(unreadCount > 99 ? '99+' : '$unreadCount'),
              child: const Icon(Icons.notifications),
            ),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}
