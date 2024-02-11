import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_monitor/core/repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Repository repo;
  AuthBloc({required this.repo}) : super(AuthInitialState()) {
    on<AuthCheckEvent>(_checkAuthState);
    on<AuthLoginEvent>(_login);
    on<AuthRegisterEvent>(_register);
    on<AuthLogoutEvent>(_logout);
  }

  Future<void> _checkAuthState(
      AuthCheckEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      final isLoggedIn = await repo.isLoggedIn();
      if (isLoggedIn) {
        emit(AuthLoggedInState());
      } else {
        emit(AuthUnauthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _login(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      await repo.login(event.email, event.password);
      emit(AuthLoggedInState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _register(
      AuthRegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      await repo.register(event.email, event.password);
      emit(AuthRegisteredState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> _logout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      await repo.logout();
      emit(AuthUnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
