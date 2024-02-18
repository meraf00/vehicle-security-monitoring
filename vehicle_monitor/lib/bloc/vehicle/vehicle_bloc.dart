import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_monitor/core/repository.dart';
import 'package:vehicle_monitor/models/vehicle.dart';

import 'vehicle_event.dart';
import 'vehicle_state.dart';

export 'vehicle_event.dart';
export 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final Repository repo;
  VehicleBloc({required this.repo}) : super(VehicleLoading()) {
    on<VehicleLoadEvent>(_loadVehicles);
    on<VehicleLockEvent>(_lockVehicle);
    on<VehicleUnlockEvent>(_unlockVehicle);
    on<DeleteVehicleEvent>(_deleteVehicle);
  }

  Future<void> _loadVehicles(
      VehicleLoadEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());

    try {
      final vehicles = await repo.getVehicles();
      emit(VehicleLoaded(vehicles, repo.streamSocket));
    } catch (e) {
      emit(VehicleErrorState(e.toString()));
    }
  }

  Future<void> _lockVehicle(
      VehicleLockEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());

    try {
      await repo.sendControlSignal(event.plate, ControlSignal.denyAccess);
      emit(VehicleLocked());
    } catch (e) {
      emit(VehicleErrorState(e.toString()));
    }
  }

  Future<void> _unlockVehicle(
      VehicleUnlockEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());

    try {
      await repo.sendControlSignal(event.plate, ControlSignal.grantAccess);
      emit(VehicleUnlocked());
    } catch (e) {
      emit(VehicleErrorState(e.toString()));
    }
  }

  Future<void> _deleteVehicle(
      DeleteVehicleEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());

    try {
      await repo.deleteVehicle(event.plate);
      emit(VehicleDeleted());
    } catch (e) {
      emit(VehicleErrorState(e.toString()));
    }
  }
}
