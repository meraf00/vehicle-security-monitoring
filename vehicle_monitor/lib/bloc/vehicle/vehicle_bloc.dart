import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_monitor/core/repository.dart';

import 'vehicle_event.dart';
import 'vehicle_state.dart';

export 'vehicle_event.dart';
export 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final Repository repo;
  VehicleBloc({required this.repo}) : super(VehicleLoading()) {
    on<VehicleLoadEvent>(_loadVehicles);
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
}
