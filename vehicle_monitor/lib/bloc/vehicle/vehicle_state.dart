import 'package:equatable/equatable.dart';
import 'package:vehicle_monitor/core/streamsocket.dart';
import 'package:vehicle_monitor/models/vehicle.dart';

sealed class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object> get props => [];
}

final class VehicleLoading extends VehicleState {}

final class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  final StreamSocket streamSocket;

  const VehicleLoaded(this.vehicles, this.streamSocket);

  @override
  List<Object> get props => [vehicles];
}

final class VehicleErrorState extends VehicleState {
  final String message;

  const VehicleErrorState(this.message);

  @override
  List<Object> get props => [message];
}

final class VehicleLocked extends VehicleState {}

final class VehicleUnlocked extends VehicleState {}

final class VehicleDeleted extends VehicleState {}
