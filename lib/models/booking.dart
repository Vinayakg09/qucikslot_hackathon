class Booking {
  final String id;
  final String slotId;
  final String userId;
  final String date;
  final String status;
  final String venueName;
  final String sport;
  final String address;
  final String startTime;
  final String endTime;
  final double price;

  const Booking({
    required this.id,
    required this.slotId,
    required this.userId,
    required this.date,
    required this.status,
    required this.venueName,
    required this.sport,
    required this.address,
    required this.startTime,
    required this.endTime,
    required this.price,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        slotId: json['slot_id'],
        userId: json['user_id'],
        date: json['date'],
        status: json['status'],
        venueName: json['venue_name'] ?? '',
        sport: json['sport'] ?? '',
        address: json['address'] ?? '',
        startTime: json['start_time'] ?? '',
        endTime: json['end_time'] ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
      );
}