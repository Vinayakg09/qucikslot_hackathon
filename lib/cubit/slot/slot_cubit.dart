import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qucik_slot/repo/repository_impl.dart';
import 'slot_state.dart';

class SlotCubit extends Cubit<SlotState> {
  SlotCubit() : super(SlotInitial());

  final RepositoryImpl _repo = RepositoryImpl();

  Future<void> loadSlots(String venueId, String date) async {
    emit(SlotLoading());
    final result = await _repo.getSlots(venueId: venueId, date: date);
    result.fold(
      (failure) => emit(SlotError(failure.message)),
      (slots) => emit(SlotLoaded(slots)),
    );
  }
}