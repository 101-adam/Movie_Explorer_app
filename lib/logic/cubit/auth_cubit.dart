import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    _authRepository.user.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> logIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await _authRepository.logIn(email: email, password: password);
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(email: email, password: password);
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> logOut() async {
    emit(AuthLoading());
    try {
      await _authRepository.logOut();
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
