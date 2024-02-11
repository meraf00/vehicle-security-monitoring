import 'package:equatable/equatable.dart';

sealed class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

final class VehicleLoadEvent extends VehicleEvent {
  const VehicleLoadEvent();
}
