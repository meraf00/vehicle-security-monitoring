import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_monitor/bloc/auth/auth_bloc.dart';
import 'package:vehicle_monitor/consts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(Assets.astuLogo, width: 180, height: 180),
            const SizedBox(
              height: 10,
            ),
            const Text('Built by'),
            const SizedBox(
              height: 10,
            ),
            const Column(
              children: [
                Text('Leul Wujira'),
                Text('Software Engineer'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Column(
              children: [
                Text('Zekarias Girma'),
                Text('Mechatronic Engineer'),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthLogoutEvent());
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
