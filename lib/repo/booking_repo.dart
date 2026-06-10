import '../models/booking.dart';
import 'api_client.dart';

class BookingRepo {
  Future<Map<String, dynamic>> createBooking({
    required String slotId,
    required String date,
    required String userId,
  }) async {
    return await ApiClient.post(
      '/bookings',
      {'slot_id': slotId, 'date': date},
      userId: userId,
    );
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    final data = await ApiClient.get('/users/$userId/bookings');
    return (data as List).map((e) => Booking.fromJson(e)).toList();
  }

  Future<void> cancelBooking(String bookingId, String userId) async {
    await ApiClient.delete('/bookings/$bookingId', userId: userId);
  }
}