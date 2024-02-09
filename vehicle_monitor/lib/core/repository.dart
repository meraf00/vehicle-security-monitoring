import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_monitor/consts.dart';
import 'package:vehicle_monitor/core/auth.dart';
import 'package:vehicle_monitor/models/vehicle.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;

class Repository {
  final SharedPreferences prefs;
  final Auth auth;

  Repository({required this.prefs, required this.auth});

  void connectToSocket(String token) {
    final socket = io.io('https://your_socket_server_url', <String, dynamic>{
      'autoConnect': false,
      'extraHeaders': <String, String>{'Authorization': token},
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to the socket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from the socket server');
    });

    socket.on('message', (data) {
      print('Received message: $data');
    });
  }

  Future<Vehicle> getVehicle(String plate) async {
    final req =
        await http.post(Uri.parse(Consts.apiBaseUrl), body: {'plate': plate});

    if (req.statusCode == 200) {
      final parsed = jsonDecode(req.body) as Map<String, dynamic>;
      return Vehicle.fromJson(parsed);
    }

    throw Exception('Failed to get vehicle');
  }

  Future<List<Vehicle>> getVehicles(String plate) async {
    final req = await http.get(Uri.parse(Consts.apiBaseUrl));

    if (req.statusCode == 200) {
      final parsed = jsonDecode(req.body) as Map<String, dynamic>;
      final vehicles = parsed['vehicles'] as List<dynamic>;
      return vehicles.map((e) => Vehicle.fromJson(e)).toList();
    }

    throw Exception('Failed to get vehicles');
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

  // Auth
  Future<void> login(String email, String password) async {
    final token = await auth.login(email, password);
    await prefs.setString('token', token);
  }

  Future<void> register(String email, String password) async {
    await auth.register(email, password);
  }
}
