import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../models/booking.dart';
import '../models/slot.dart';
import '../models/user.dart';
import '../models/venue.dart';
import '../res/app_constants.dart';
import 'repository.dart';

class RepositoryImpl implements Repository {
  final _client = http.Client();
  final _base = AppConstants.baseUrl;

  Map<String, String> _headers({String? userId}) => {
        'Content-Type': 'application/json',
        if (userId != null) 'X-User-Id': userId,
      };

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final res = await _client.get(Uri.parse('$_base/users'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        return Right(data.map((e) => User.fromJson(e)).toList());
      }
      return Left(Failure('Failed to load users'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Venue>>> getVenues() async {
    try {
      final res = await _client.get(Uri.parse('$_base/venues'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        return Right(data.map((e) => Venue.fromJson(e)).toList());
      }
      return Left(Failure('Failed to load venues'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Slot>>> getSlots({
    required String venueId,
    required String date,
  }) async {
    try {
      final res = await _client.get(
        Uri.parse('$_base/venues/$venueId/slots?date=$date'),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        return Right(data.map((e) => Slot.fromJson(e)).toList());
      }
      return Left(Failure('Failed to load slots'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Booking>> createBooking({
    required String slotId,
    required String date,
    required String userId,
  }) async {
    try {
      final res = await _client.post(
        Uri.parse('$_base/bookings'),
        headers: _headers(userId: userId),
        body: jsonEncode({'slot_id': slotId, 'date': date}),
      );
      if (res.statusCode == 201) {
        return Right(Booking.fromJson(jsonDecode(res.body)));
      }
      if (res.statusCode == 409) {
        return Left(Failure('CONFLICT'));
      }
      return Left(Failure('Failed to create booking'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getUserBookings({
    required String userId,
  }) async {
    try {
      final res = await _client.get(
        Uri.parse('$_base/users/$userId/bookings'),
        headers: _headers(userId: userId),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        return Right(data.map((e) => Booking.fromJson(e)).toList());
      }
      return Left(Failure('Failed to load bookings'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelBooking({
    required String bookingId,
    required String userId,
  }) async {
    try {
      final res = await _client.delete(
        Uri.parse('$_base/bookings/$bookingId'),
        headers: _headers(userId: userId),
      );
      if (res.statusCode == 200) return const Right(true);
      return Left(Failure('Failed to cancel booking'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}