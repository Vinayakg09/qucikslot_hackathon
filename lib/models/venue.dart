class Venue {
  final String id;
  final String name;
  final String sport;
  final String address;
  final String imageUrl;

  const Venue({
    required this.id,
    required this.name,
    required this.sport,
    required this.address,
    required this.imageUrl,
  });

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        id: json['id'],
        name: json['name'],
        sport: json['sport'],
        address: json['address'],
        imageUrl: json['image_url'] ?? '',
      );
}