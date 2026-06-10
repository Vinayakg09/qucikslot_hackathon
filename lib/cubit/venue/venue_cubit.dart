import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qucik_slot/repo/repository_impl.dart';
import 'venue_state.dart';

class VenueCubit extends Cubit<VenueState> {
  VenueCubit() : super(VenueInitial());

  final RepositoryImpl _repo = RepositoryImpl();

  Future<void> loadVenues() async {
    emit(VenueLoading());
    final result = await _repo.getVenues();
    result.fold(
      (failure) => emit(VenueError(failure.message)),
      (venues) => emit(VenueLoaded(venues)),
    );
  }
}
