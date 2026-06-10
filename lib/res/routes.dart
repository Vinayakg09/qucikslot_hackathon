import 'package:go_router/go_router.dart';
import 'package:qucik_slot/view/screens/login_screen.dart';
import 'package:qucik_slot/view/screens/my_bookings_screen.dart';
import 'package:qucik_slot/view/screens/venue_detail_screen.dart';
import 'package:qucik_slot/view/screens/venue_list_screen.dart';
import '../models/venue.dart';

final GoRouter router = GoRouter(
  initialLocation: RouteTo.login,
  routes: [
    GoRoute(
      path: RouteTo.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteTo.venueList,
      builder: (context, state) {
        final data = state.extra as Map<String, String>;
        return VenueListScreen(
          userId: data['userId']!,
          userName: data['userName']!,
        );
      },
    ),
    GoRoute(
      path: RouteTo.venueDetail,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return VenueDetailScreen(
          venue: data['venue'] as Venue,
          userId: data['userId'] as String,
        );
      },
    ),
    GoRoute(
      path: RouteTo.myBookings,
      builder: (context, state) {
        final userId = state.extra as String;
        return MyBookingsScreen(userId: userId);
      },
    ),
  ],
);

abstract class RouteTo {
  static const String login = '/';
  static const String venueList = '/venueList';
  static const String venueDetail = '/venueDetail';
  static const String myBookings = '/myBookings';
}
