import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qucik_slot/repo/repository_impl.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final RepositoryImpl _repo = RepositoryImpl();

  Future<void> loadUsers() async {
    emit(AuthLoading());
    final result = await _repo.getUsers();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (users) => emit(AuthUsersLoaded(users)),
    );
  }

  void selectUser(user) => emit(AuthAuthenticated(user));
}