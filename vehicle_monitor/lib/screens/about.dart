import 'package:flutter/material.dart';
import 'package:vehicle_monitor/consts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Image.asset(Assets.astuLogo, width: 180, height: 180),
        const Text('Built by'),
        const Column(
          children: [
            Text('Leul Wujira'),
            Text('Software Engineer'),
          ],
        ),
        const Column(
          children: [
            Text('Zekarias Girma'),
            Text('Mechatronic Engineer'),
          ],
        ),
      ],
    ));
  }
}
