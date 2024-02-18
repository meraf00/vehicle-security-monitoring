import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import 'package:vehicle_monitor/bloc/vehicle/vehicle_bloc.dart';
import 'package:vehicle_monitor/bloc/vehicle_auth/vehicle_auth_bloc.dart';

import 'package:vehicle_monitor/injection.dart';
import 'package:vehicle_monitor/models/vehicle.dart';
import 'package:vehicle_monitor/theme/app_colors.dart';

class VehicleListScreen extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();

  VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<BiometricAuthBloc>(),
      child: BlocProvider(
        create: (context) =>
            serviceLocator<VehicleBloc>()..add(const VehicleLoadEvent()),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.blue,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/about');
                },
                child: const Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            title: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Vehicles',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.white,
                    ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.blue,
                  ],
                  stops: [0.9, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: BlocBuilder<VehicleBloc, VehicleState>(
                  builder: (context, state) {
                if (state is VehicleLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is VehicleErrorState) {
                  return Center(child: Text(state.message));
                } else if (state is VehicleLoaded) {
                  return StreamBuilder(
                      stream: state.streamSocket.getResponse,
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        final vehicles = <Vehicle>[];
                        for (var vehicle in state.vehicles) {
                          final plate = snapshot.data?['plate'];
                          Status status = Status.disconnected;

                          if (state.streamSocket.vehiclesData
                              .containsKey(plate)) {
                            if (state
                                .streamSocket.vehiclesData[plate]!['lastSeen']!
                                .isAfter(DateTime.now()
                                    .subtract(const Duration(seconds: 5)))) {
                              status = Status.connected;
                            } else {
                              status = Status.disconnected;
                            }

                            if (state.streamSocket
                                    .vehiclesData[plate]!['locked'] ==
                                LockStatus.locked) {
                              vehicle.lockStatus = LockStatus.locked;
                            } else {
                              vehicle.lockStatus = LockStatus.unlocked;
                            }
                          }

                          if (vehicle.plate == plate) {
                            final location =
                                "${snapshot.data?['latitude'].toString()}, ${snapshot.data?['longitude'].toString()}";

                            vehicles.add(Vehicle(
                                location: location,
                                plate: plate,
                                status: status,
                                lockStatus: vehicle.lockStatus,
                                incidents: vehicle.incidents));
                          } else {
                            final plate = vehicle.plate;
                            status = Status.disconnected;

                            if (state.streamSocket.vehiclesData
                                .containsKey(plate)) {
                              if (state.streamSocket
                                  .vehiclesData[plate]!['lastSeen']!
                                  .isAfter(DateTime.now()
                                      .subtract(const Duration(seconds: 5)))) {
                                status = Status.connected;
                              } else {
                                status = Status.disconnected;
                              }

                              if (state.streamSocket
                                      .vehiclesData[plate]!['locked'] ==
                                  LockStatus.locked) {
                                vehicle.lockStatus = LockStatus.locked;
                              } else {
                                vehicle.lockStatus = LockStatus.unlocked;
                              }
                            }
                            vehicles.add(Vehicle(
                                location: vehicle.location,
                                plate: vehicle.plate,
                                status: status,
                                lockStatus: vehicle.lockStatus,
                                incidents: vehicle.incidents));
                          }
                        }
                        return VehicleList(vehicles: vehicles);
                      });
                } else {
                  return const Center(child: Text('Something went wrong.'));
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class VehicleList extends StatelessWidget {
  final List<Vehicle> vehicles;

  const VehicleList({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return vehicles.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('You haven\'t added any vehicle.'),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<VehicleBloc>(context)
                        .add(const VehicleLoadEvent());
                  },
                  child: const Text('Refresh'),
                )
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<VehicleBloc>(context)
                  .add(const VehicleLoadEvent());
            },
            child: ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => {
                    Navigator.pushNamed(context, '/vehicle',
                        arguments: vehicles[index]),
                  },

                  contentPadding: const EdgeInsets.all(9.0),

                  horizontalTitleGap: 30,

                  //
                  leading: CircleAvatar(
                    backgroundColor:
                        vehicles[index].status == Status.disconnected
                            ? AppColors.red
                            : Colors.green,
                    child: const Icon(
                      Icons.directions_car,
                      color: AppColors.white,
                    ),
                  ),
                  //
                  trailing: PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          onTap: () {
                            if (vehicles[index].lockStatus ==
                                LockStatus.locked) {
                              context.read<BiometricAuthBloc>().add(
                                  AuthenticateLocalEvent(vehicles[index].plate,
                                      ControlSignal.grantAccess));
                            } else {
                              context.read<BiometricAuthBloc>().add(
                                  AuthenticateLocalEvent(vehicles[index].plate,
                                      ControlSignal.denyAccess));
                            }
                          },
                          child: vehicles[index].lockStatus == LockStatus.locked
                              ? const Text('Unlock')
                              : const Text('Lock'),
                        ),
                      ];
                    },
                  ),

                  //
                  title: Row(children: [
                    Text(
                      vehicles[index].plate,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 10),
                    if (vehicles[index].lockStatus == LockStatus.locked)
                      const Icon(
                        Icons.lock,
                        color: AppColors.gray700,
                        size: 16,
                      )
                  ]),

                  //
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: vehicles[index].status == Status.disconnected
                            ? AppColors.red
                            : Colors.green,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      vehicles[index].status == Status.disconnected
                          ? Text('Disconnected',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.red))
                          : Text('Connected',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.green)),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
