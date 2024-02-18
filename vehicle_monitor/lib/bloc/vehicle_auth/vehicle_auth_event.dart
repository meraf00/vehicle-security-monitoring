import 'package:equatable/equatable.dart';
import 'package:vehicle_monitor/models/vehicle.dart';

sealed class VehicleAuthEvent extends Equatable {
  const VehicleAuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthenticateLocalEvent extends VehicleAuthEvent {
  final String plate;
  final ControlSignal signal;

  const AuthenticateLocalEvent(this.plate, this.signal);
}
