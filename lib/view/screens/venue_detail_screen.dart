import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../cubit/booking/booking_cubit.dart';
import '../../cubit/booking/booking_state.dart';
import '../../cubit/slot/slot_cubit.dart';
import '../../cubit/slot/slot_state.dart';
import '../../models/slot.dart';
import '../../models/venue.dart';
import '../../res/app_colors.dart';
import '../widgets/slot_grid.dart';

class VenueDetailScreen extends StatefulWidget {
  final Venue venue;
  final String userId;
  const VenueDetailScreen({
    super.key,
    required this.venue,
    required this.userId,
  });

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  final SlotCubit slotCubit = SlotCubit();
  final BookingCubit bookingCubit = BookingCubit();

  DateTime _selectedDate = DateTime.now();

  String get _formattedDate => DateFormat('yyyy-MM-dd').format(_selectedDate);
  String get _displayDate => DateFormat('EEE, MMM d').format(_selectedDate);

  @override
  void initState() {
    super.initState();
    slotCubit.loadSlots(widget.venue.id, _formattedDate);
  }

  @override
  void dispose() {
    slotCubit.close();
    bookingCubit.close();
    super.dispose();
  }

  void _loadSlots() {
    slotCubit.loadSlots(widget.venue.id, _formattedDate);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.card,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      _loadSlots();
    }
  }

  void _onSlotTap(Slot slot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocConsumer<BookingCubit, BookingState>(
        bloc: bookingCubit,
        listener: (context, state) {
          if (state is BookingSuccess) {
            Navigator.pop(context);
            _loadSlots();
            ScaffoldMessenger.of(this.context).showSnackBar(
              const SnackBar(
                content: Text('✅ Slot booked successfully!'),
                backgroundColor: AppColors.available,
              ),
            );
          } else if (state is BookingConflict) {
            Navigator.pop(context);
            _loadSlots();
            ScaffoldMessenger.of(this.context).showSnackBar(
              const SnackBar(
                content: Text(
                  '⚠️ Sorry! This slot was just taken. Please pick another.',
                ),
                backgroundColor: AppColors.booked,
              ),
            );
          } else if (state is BookingError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(this.context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.booked,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _infoRow(Icons.sports, widget.venue.sport),
                _infoRow(Icons.stadium, widget.venue.name),
                _infoRow(Icons.location_on, widget.venue.address),
                _infoRow(Icons.calendar_today, _displayDate),
                _infoRow(
                  Icons.access_time,
                  '${slot.startTime} - ${slot.endTime}',
                ),
                _infoRow(Icons.currency_rupee, '₹${slot.price.toInt()}'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: state is BookingLoading
                        ? null
                        : () {
                            bookingCubit.createBooking(
                              slotId: slot.id,
                              date: _formattedDate,
                              userId: widget.userId,
                            );
                          },
                    child: state is BookingLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Confirm Booking',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.background,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.venue.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: widget.venue.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    Container(color: AppColors.surface),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.venue.address,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.venue.sport,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text(
                        'Select Date',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: AppColors.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _displayDate,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _legendDot(AppColors.available, 'Available'),
                      const SizedBox(width: 16),
                      _legendDot(AppColors.booked, 'Booked'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<SlotCubit, SlotState>(
                    bloc: slotCubit,
                    builder: (context, state) {
                      if (state is SlotLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }
                      if (state is SlotError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: AppColors.booked),
                          ),
                        );
                      }
                      if (state is SlotLoaded) {
                        if (state.slots.isEmpty) {
                          return const Center(
                            child: Text(
                              'No slots available',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          );
                        }
                        return SlotGrid(
                          slots: state.slots,
                          onSlotTap: _onSlotTap,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
