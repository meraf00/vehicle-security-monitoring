import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

sealed class VehicleAuthState extends Equatable {
  const VehicleAuthState();

  @override
  List<Object?> get props => [];
}

final class BiometricInitailState extends VehicleAuthState {}

final class VehicleCanCheckBiometric extends VehicleAuthState {}

final class LocalAuthLoading extends VehicleAuthState {}

final class AvailableBiometrics extends VehicleAuthState {
  final List<BiometricType> availableBiometrics;

  const AvailableBiometrics(this.availableBiometrics);

  @override
  List<Object> get props => [availableBiometrics];
}

final class AuthenticateLocalState extends VehicleAuthState {
  final bool authenticated;

  const AuthenticateLocalState(this.authenticated);

  @override
  List<Object> get props => [authenticated];
}

final class VehicleAuthErrorState extends VehicleAuthState {
  final String message;

  const VehicleAuthErrorState(this.message);

  @override
  List<Object> get props => [message];
}
