import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../cubit/booking/booking_cubit.dart';
import '../../cubit/venue/venue_cubit.dart';
import '../../cubit/venue/venue_state.dart';
import '../../res/app_colors.dart';
import '../../res/routes.dart';
import '../widgets/venue_card.dart';

class VenueListScreen extends StatefulWidget {
  final String userId;
  final String userName;
  const VenueListScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<VenueListScreen> createState() => _VenueListScreenState();
}

class _VenueListScreenState extends State<VenueListScreen> {
  final VenueCubit venueCubit = VenueCubit();
  final BookingCubit bookingCubit = BookingCubit();

  @override
  void initState() {
    super.initState();
    venueCubit.loadVenues();
  }

  @override
  void dispose() {
    venueCubit.close();
    bookingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'QuickSlot 🏸',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Book your slot today',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: AppColors.primary),
            onPressed: () => context.push(
              RouteTo.myBookings,
              extra: widget.userId,
            ),
          ),
        ],
      ),
      body: BlocBuilder<VenueCubit, VenueState>(
        bloc: venueCubit,
        builder: (context, state) {
          if (state is VenueLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is VenueError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.booked,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () => venueCubit.loadVenues(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is VenueLoaded) {
            if (state.venues.isEmpty) {
              return const Center(
                child: Text(
                  'No venues found',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => venueCubit.loadVenues(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.venues.length,
                itemBuilder: (context, index) {
                  final venue = state.venues[index];
                  return VenueCard(
                    venue: venue,
                    onTap: () => context.push(
                      RouteTo.venueDetail,
                      extra: {'venue': venue, 'userId': widget.userId},
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
