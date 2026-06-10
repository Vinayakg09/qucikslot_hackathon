import '../models/slot.dart';
import 'api_client.dart';

class SlotRepo {
  Future<List<Slot>> getSlots(String venueId, String date) async {
    final data = await ApiClient.get('/venues/$venueId/slots?date=$date');
    return (data as List).map((e) => Slot.fromJson(e)).toList();
  }
}