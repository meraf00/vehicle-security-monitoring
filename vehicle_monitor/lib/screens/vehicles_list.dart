import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_monitor/bloc/vehicle/vehicle_bloc.dart';
import 'package:vehicle_monitor/core/streamsocket.dart';
import 'package:vehicle_monitor/injection.dart';
import 'package:vehicle_monitor/models/vehicle.dart';
import 'package:vehicle_monitor/theme/app_colors.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          serviceLocator<VehicleBloc>()..add(const VehicleLoadEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blue,
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
                // return StreamBuilder(
                //     stream: state.streamSocket.getResponse,
                //     builder:
                //         (BuildContext context, AsyncSnapshot<String> snapshot) {
                //       final vehicles = <Vehicle>[];
                //       for (var vehicle in state.vehicles) {
                //         vehicles.add(vehicle);
                //       }
                return VehicleList(vehicles: state.vehicles);
                // });
              } else {
                return const Center(child: Text('Something went wrong.'));
              }
            }),
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
        ? const Center(child: Text('You haven\'t added any vehicle.'))
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
                        const PopupMenuItem(
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          child: Text('Remove'),
                        ),
                      ];
                    },
                  ),

                  //
                  title: Text(
                    vehicles[index].plate,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

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
