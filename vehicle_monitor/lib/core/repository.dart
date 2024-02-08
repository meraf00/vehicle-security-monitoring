import 'package:vehicle_monitor/models/vehicle.dart';

class Repository {
  Future<Vehicle> getVehicle(String plate) async {
    throw UnimplementedError();
  }

  Future<Vehicle> getVehicles(String plate) async {
    throw UnimplementedError();
  }

  Future<Vehicle> trackVehicle(String plate) async {
    throw UnimplementedError();
  }

  Future<Vehicle> sendControlSignal(String plate, ControlSignal signal) async {
    switch (signal) {
      case ControlSignal.grantAccess:
        throw UnimplementedError();
      case ControlSignal.denyAccess:
        throw UnimplementedError();
      case ControlSignal.terminate:
        throw UnimplementedError();
      default:
        throw UnimplementedError();
    }
  }
}
