import 'package:vehicle_monitor/models/incident.dart';

enum ControlSignal { grantAccess, denyAccess }

enum Status {
  connected,
  disconnected;

  bool operator >(Status other) => index > other.index;
  bool operator <(Status other) => index < other.index;
  bool operator >=(Status other) => index >= other.index;
  bool operator <=(Status other) => index <= other.index;
}

enum LockStatus { locked, unlocked }

class Vehicle {
  String location;
  String plate;
  Status status;
  LockStatus lockStatus;

  List<Incident> incidents;

  Vehicle(
      {required this.location,
      required this.plate,
      this.status = Status.disconnected,
      this.lockStatus = LockStatus.locked,
      this.incidents = const []});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      location: json['location'] ?? '',
      plate: json['plate'] ?? '',
      status: Status.disconnected,
      incidents: (json['incidents'] as List<dynamic>)
          .map((e) => Incident.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Vehicle: $plate, $location, $status, $lockStatus, $incidents';
  }
}
