class Slot {
  final String id;
  final String venueId;
  final String startTime;
  final String endTime;
  final double price;
  final bool isBooked;
  final String bookingId;

  const Slot({
    required this.id,
    required this.venueId,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.isBooked,
    required this.bookingId,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json['id'],
        venueId: json['venue_id'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        price: (json['price'] as num).toDouble(),
        isBooked: json['is_booked'] ?? false,
        bookingId: json['booking_id'] ?? '',
      );
}