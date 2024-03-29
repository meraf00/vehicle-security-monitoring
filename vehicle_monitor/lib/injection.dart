import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_monitor/bloc/auth/auth_bloc.dart';
import 'package:vehicle_monitor/bloc/vehicle/vehicle_bloc.dart';
import 'package:vehicle_monitor/bloc/vehicle_auth/vehicle_auth_bloc.dart';
import 'package:vehicle_monitor/core/auth.dart';
import 'package:vehicle_monitor/core/notification_service.dart';
import 'package:vehicle_monitor/core/repository.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // Bloc
  serviceLocator.registerFactory(() => AuthBloc(
        repo: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => VehicleBloc(
        repo: serviceLocator(),
      ));
  serviceLocator.registerFactory(() => BiometricAuthBloc(serviceLocator()));

  serviceLocator.registerLazySingleton(
    () => Repository(auth: serviceLocator(), prefs: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => Auth(),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  final notification = LocalNotificationService();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => notification);
}
