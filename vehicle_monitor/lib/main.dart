import 'package:flutter/material.dart';
import 'package:vehicle_monitor/consts.dart';
import 'package:vehicle_monitor/screens/about.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Consts.appName,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const AboutScreen(),
    );
  }
}
