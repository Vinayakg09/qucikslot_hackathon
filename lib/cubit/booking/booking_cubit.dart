import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qucik_slot/repo/repository_impl.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  final RepositoryImpl _repo = RepositoryImpl();

  Future<void> loadUserBookings(String userId) async {
    emit(BookingLoading());
    final result = await _repo.getUserBookings(userId: userId);
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (bookings) => emit(BookingLoaded(bookings)),
    );
  }

  Future<void> createBooking({
    required String slotId,
    required String date,
    required String userId,
  }) async {
    emit(BookingLoading());
    final result = await _repo.createBooking(
      slotId: slotId,
      date: date,
      userId: userId,
    );
    result.fold(
      (failure) => failure.message == 'CONFLICT'
          ? emit(BookingConflict())
          : emit(BookingError(failure.message)),
      (booking) => emit(BookingSuccess(booking.id)),
    );
  }

  Future<void> cancelBooking(String bookingId, String userId) async {
    final result = await _repo.cancelBooking(
      bookingId: bookingId,
      userId: userId,
    );
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) => loadUserBookings(userId),
    );
  }
}