import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vehicle_monitor/core/repository.dart';

import 'vehicle_auth_event.dart';
import 'vehicle_auth_state.dart';

export 'vehicle_auth_event.dart';
export 'vehicle_auth_state.dart';

class BiometricAuthBloc extends Bloc<VehicleAuthEvent, VehicleAuthState> {
  final LocalAuthentication auth = LocalAuthentication();
  final Repository repository;

  BiometricAuthBloc(this.repository) : super(BiometricInitailState()) {
    on<AuthenticateLocalEvent>(_authenticate);
  }

  Future<void> _authenticate(
      AuthenticateLocalEvent event, Emitter<VehicleAuthState> emit) async {
    emit(LocalAuthLoading());

    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      emit(VehicleAuthErrorState(e.toString()));
      return;
    }

    repository.sendControlSignal(event.plate, event.signal);

    emit(AuthenticateLocalState(authenticated));
  }
}
