import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_monitor/bloc/auth/auth_bloc.dart';
import 'package:vehicle_monitor/injection.dart';
import 'package:vehicle_monitor/screens/snackbar.dart';
import '../consts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedInState) {
                Navigator.of(context).pushReplacementNamed('/vehicles');
              } else if (state is AuthUnauthenticatedState) {
                Navigator.of(context).pushReplacementNamed('/login');
              } else if (state is AuthErrorState) {
                showError(context, state.message);
              } else if (state is AuthRegisteredState) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: Image.asset(Assets.astuLogo)),
      ),
    );
  }
}
