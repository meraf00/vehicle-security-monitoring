import 'package:flutter/material.dart';
import 'package:vehicle_monitor/screens/login.dart';
import 'package:vehicle_monitor/screens/register.dart';
import 'consts.dart';
import 'screens/about.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Consts.appName,
      theme: AppTheme.themeData,
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
