import 'package:equatable/equatable.dart';

sealed class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

final class VehicleLoadEvent extends VehicleEvent {
  const VehicleLoadEvent();
}

final class VehicleLockEvent extends VehicleEvent {
  final String plate;
  const VehicleLockEvent(this.plate);

  @override
  List<Object?> get props => [plate];
}

final class VehicleUnlockEvent extends VehicleEvent {
  final String plate;
  const VehicleUnlockEvent(this.plate);

  @override
  List<Object?> get props => [plate];
}

final class DeleteVehicleEvent extends VehicleEvent {
  final String plate;
  const DeleteVehicleEvent(this.plate);

  @override
  List<Object?> get props => [plate];
}
