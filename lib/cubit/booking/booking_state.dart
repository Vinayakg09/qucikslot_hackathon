import '../../models/booking.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Booking> bookings;
  BookingLoaded(this.bookings);
}

class BookingSuccess extends BookingState {
  final String bookingId;
  BookingSuccess(this.bookingId);
}

class BookingConflict extends BookingState {}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}