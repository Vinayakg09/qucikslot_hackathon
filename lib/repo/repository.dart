import 'package:either_dart/either.dart';
import '../models/booking.dart';
import '../models/slot.dart';
import '../models/user.dart';
import '../models/venue.dart';
import '../res/app_constants.dart';

abstract class Repository {
  Future<Either<Failure, List<User>>> getUsers();

  Future<Either<Failure, List<Venue>>> getVenues();

  Future<Either<Failure, List<Slot>>> getSlots({
    required String venueId,
    required String date,
  });

  Future<Either<Failure, Booking>> createBooking({
    required String slotId,
    required String date,
    required String userId,
  });

  Future<Either<Failure, List<Booking>>> getUserBookings({
    required String userId,
  });

  Future<Either<Failure, bool>> cancelBooking({
    required String bookingId,
    required String userId,
  });
}