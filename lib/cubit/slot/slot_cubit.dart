import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/slot_repo.dart';
import 'slot_state.dart';

class SlotCubit extends Cubit<SlotState> {
  final SlotRepo _repo;
  SlotCubit(this._repo) : super(SlotInitial());

  Future<void> loadSlots(String venueId, String date) async {
    emit(SlotLoading());
    try {
      final slots = await _repo.getSlots(venueId, date);
      emit(SlotLoaded(slots));
    } catch (e) {
      emit(SlotError(e.toString()));
    }
  }
}