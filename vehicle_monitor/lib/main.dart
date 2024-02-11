import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_monitor/bloc/auth/auth_bloc.dart';
import 'package:vehicle_monitor/bloc_observer.dart';
import 'package:vehicle_monitor/screens/login.dart';
import 'package:vehicle_monitor/screens/register.dart';
import 'package:vehicle_monitor/screens/splash_screen.dart';
import 'package:vehicle_monitor/screens/vehicle_detail.dart';
import 'package:vehicle_monitor/screens/vehicles_list.dart';
import 'consts.dart';
import 'screens/about.dart';
import 'theme/app_theme.dart';
import 'injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  Bloc.observer = SimpleBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.serviceLocator<AuthBloc>()..add(const AuthCheckEvent()),
      child: MaterialApp(
        title: Consts.appName,
        theme: AppTheme.themeData,
        home: SplashScreen(),
        routes: {
          '/vehicle': (context) => VehicleScreen(),
          '/vehicles': (context) => VehicleListScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/about': (context) => const AboutScreen(),
        },
      ),
    );
  }
}
