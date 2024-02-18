import 'dart:convert';

import 'package:http/http.dart' as http;
import '../consts.dart';

class Auth {
  Future<String> login(String email, String password) async {
    final request = await http.post(
        Uri.parse('${Consts.apiBaseUrl}/auth/login'),
        body: {'email': email, 'password': password});

    if (request.statusCode == 200) {
      final token = jsonDecode(request.body)['token'] as String;
      return token;
    } else if (request.statusCode == 401) {
      throw Exception('Invalid email or password');
    }

    throw Exception('Failed to login');
  }

  Future<void> register(String email, String password) async {
    final request = await http.post(
        Uri.parse('${Consts.apiBaseUrl}/auth/register'),
        body: {'email': email, 'password': password});

    if (request.statusCode == 201) {
      return;
    } else if (request.statusCode == 400) {
      throw Exception('Invalid email or short password (min 6)');
    } else if (request.statusCode == 401) {
      throw Exception('Email already exists');
    }

    throw Exception('Failed to register');
  }
}
