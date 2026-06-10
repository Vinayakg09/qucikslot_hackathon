import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user.dart';
import '../../repo/api_client.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> loadUsers() async {
    emit(AuthLoading());
    try {
      final data = await ApiClient.get('/users');
      final users = (data as List).map((e) => User.fromJson(e)).toList();
      emit(AuthUsersLoaded(users));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void selectUser(User user) {
    emit(AuthAuthenticated(user));
  }
}