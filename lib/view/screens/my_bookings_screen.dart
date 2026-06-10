import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/booking/booking_cubit.dart';
import '../../cubit/booking/booking_state.dart';
import '../../res/app_colors.dart';
import '../widgets/booking_card.dart';

class MyBookingsScreen extends StatefulWidget {
  final String userId;
  const MyBookingsScreen({super.key, required this.userId});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late final BookingCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BookingCubit();
    cubit.loadUserBookings(widget.userId);
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  void _confirmCancel(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          'Cancel Booking',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to cancel this booking?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'No',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.cancelBooking(bookingId, widget.userId);
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: AppColors.booked),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is BookingError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.booked),
              ),
            );
          }
          if (state is BookingLoaded) {
            if (state.bookings.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.textSecondary,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No bookings yet',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Book a slot to see it here',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return BookingCard(
                  booking: booking,
                  onCancel: () => _confirmCancel(context, booking.id),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}