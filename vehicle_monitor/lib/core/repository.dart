import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_monitor/consts.dart';
import 'package:vehicle_monitor/core/auth.dart';
import 'package:vehicle_monitor/core/notification_service.dart';
import 'package:vehicle_monitor/core/streamsocket.dart';
import 'package:vehicle_monitor/injection.dart';
import 'package:vehicle_monitor/models/incident.dart';
import 'package:vehicle_monitor/models/vehicle.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'dart:async';

class Repository {
  final SharedPreferences prefs;
  final Auth auth;
  StreamSocket streamSocket = StreamSocket();

  final io.Socket socket;

  Repository({required this.prefs, required this.auth})
      : socket = io.io(Consts.apiBaseUrl, <String, dynamic>{
          'autoConnect': false,
          'transports': ['websocket'],
          'extraHeaders': <String, String>{
            'authorization': prefs.getString('token') ?? ''
          },
        });

  void connectToSocket() {
    streamSocket.dispose();
    streamSocket = StreamSocket();

    socket.connect();

    socket.onConnect((_) {
      print('Connected to the socket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from the socket server');
    });

    socket.on('vehicle_status', (data) {
      streamSocket.vehiclesData[data['plate']] = {
        'lastSeen': DateTime.now(),
        'locked': data['locked'] ? LockStatus.locked : LockStatus.unlocked,
      };

      streamSocket.addResponse(data);
    });

    socket.on('vehicle_incident', (data) {
      serviceLocator<LocalNotificationService>().showNotificationAndroid(
        'Incident',
        'Incident detected on ${data['plate']}',
      );
    });
  }

  Future<Vehicle> getVehicle(String plate) async {
    final req = await http
        .get(Uri.parse('${Consts.apiBaseUrl}/vehicles/$plate'), headers: {
      'Authorization': "Bearer ${prefs.getString('token') ?? ''}",
    });

    if (req.statusCode == 200) {
      final parsed = jsonDecode(req.body) as Map<String, dynamic>;
      return Vehicle.fromJson(parsed);
    }

    throw Exception('Failed to get vehicle');
  }

  Future<List<Vehicle>> getVehicles() async {
    final req =
        await http.get(Uri.parse('${Consts.apiBaseUrl}/vehicles'), headers: {
      'Authorization': "Bearer ${prefs.getString('token') ?? ''}",
    });

    if (req.statusCode == 200) {
      connectToSocket();
      final parsed = jsonDecode(req.body) as Map<String, dynamic>;
      print(req.body);
      final vehicles = parsed['vehicles'] as List<dynamic>;
      print(vehicles.map((e) => Vehicle.fromJson(e)).toList());
      return vehicles.map((e) => Vehicle.fromJson(e)).toList();
    }

    throw Exception('Failed to get vehicles');
  }

  Future<void> sendControlSignal(String plate, ControlSignal signal) async {
    switch (signal) {
      case ControlSignal.grantAccess:
        socket.emit('unlock', {"plate": plate});
      case ControlSignal.denyAccess:
        socket.emit('lock', {"plate": plate});
      default:
        throw UnimplementedError();
    }
  }

  // Auth
  Future<bool> login(String email, String password) async {
    final token = await auth.login(email, password);
    await prefs.setString('token', token);
    return true;
  }

  Future<bool> register(String email, String password) async {
    await auth.register(email, password);
    return true;
  }

  Future<bool> logout() async {
    await prefs.remove('token');
    return true;
  }

  Future<bool> isLoggedIn() async {
    return prefs.containsKey('token');
  }

  Future<List<Incident>> getIncident(String plate) async {
    final req = await http.get(
        Uri.parse('${Consts.apiBaseUrl}/vehicles/$plate/incidents'),
        headers: {
          'Authorization': "Bearer ${prefs.getString('token') ?? ''}",
        });

    if (req.statusCode == 200) {
      final parsed = jsonDecode(req.body) as Map<String, dynamic>;
      final incidents = parsed['incidents'] as List<dynamic>;
      return incidents.map((e) => Incident.fromJson(e)).toList();
    }

    throw Exception('Failed to get incidents');
  }

  Future<void> deleteVehicle(String plate) async {
    final req = await http.delete(
      Uri.parse('${Consts.apiBaseUrl}/vehicles/$plate'),
      headers: {
        'Authorization': "Bearer ${prefs.getString('token') ?? ''}",
      },
    );

    if (req.statusCode != 200) {
      throw Exception('Failed to delete vehicle');
    }
  }
}
