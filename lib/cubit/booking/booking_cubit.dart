import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/booking_repo.dart';
import '../../repo/api_client.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo _repo;
  BookingCubit(this._repo) : super(BookingInitial());

  Future<void> loadUserBookings(String userId) async {
    emit(BookingLoading());
    try {
      final bookings = await _repo.getUserBookings(userId);
      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> createBooking({
    required String slotId,
    required String date,
    required String userId,
  }) async {
    emit(BookingLoading());
    try {
      final result = await _repo.createBooking(
        slotId: slotId,
        date: date,
        userId: userId,
      );
      emit(BookingSuccess(result['id']));
    } on ConflictException {
      emit(BookingConflict());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> cancelBooking(String bookingId, String userId) async {
    try {
      await _repo.cancelBooking(bookingId, userId);
      await loadUserBookings(userId);
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}