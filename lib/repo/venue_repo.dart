import '../models/venue.dart';
import 'api_client.dart';

class VenueRepo {
  Future<List<Venue>> getVenues() async {
    final data = await ApiClient.get('/venues');
    return (data as List).map((e) => Venue.fromJson(e)).toList();
  }
}