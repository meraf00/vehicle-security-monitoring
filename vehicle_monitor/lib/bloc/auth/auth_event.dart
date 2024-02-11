import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthCheckEvent extends AuthEvent {
  const AuthCheckEvent();
}

final class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

final class AuthRegisterEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthRegisterEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

final class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}
