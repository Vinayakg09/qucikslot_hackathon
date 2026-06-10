import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/venue_repo.dart';
import 'venue_state.dart';

class VenueCubit extends Cubit<VenueState> {
  final VenueRepo _repo;
  VenueCubit(this._repo) : super(VenueInitial());

  Future<void> loadVenues() async {
    emit(VenueLoading());
    try {
      final venues = await _repo.getVenues();
      emit(VenueLoaded(venues));
    } catch (e) {
      emit(VenueError(e.toString()));
    }
  }
}