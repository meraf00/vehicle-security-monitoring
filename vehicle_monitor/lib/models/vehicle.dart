enum ControlSignal { grantAccess, denyAccess, terminate }

enum Status {
  connected,
  disconnected;

  bool operator >(Status other) => index > other.index;
  bool operator <(Status other) => index < other.index;
  bool operator >=(Status other) => index >= other.index;
  bool operator <=(Status other) => index <= other.index;
}

class Vehicle {
  String location;
  String plate;
  Status status;

  Vehicle(
      {required this.location,
      required this.plate,
      this.status = Status.disconnected});
}
