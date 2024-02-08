import 'package:flutter/material.dart';
import 'package:vehicle_monitor/consts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Image.asset(Assets.astuLogo, width: 200, height: 200),
        Column(
          children: [
            Text('Leul Wujira'),
            Text('Software Engineer'),
          ],
        ),
        Column(
          children: [
            Text('Zekarias'),
            Text('Software Engineer'),
          ],
        ),
      ],
    ));
  }
}
