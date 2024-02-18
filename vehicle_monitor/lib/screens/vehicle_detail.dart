import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:vehicle_monitor/bloc/vehicle/vehicle_bloc.dart';
import 'package:vehicle_monitor/injection.dart';
import 'package:vehicle_monitor/models/incident.dart';
import 'package:vehicle_monitor/models/vehicle.dart';
import 'package:vehicle_monitor/screens/snackbar.dart';
import 'package:vehicle_monitor/theme/app_colors.dart';

class VehicleScreen extends StatelessWidget {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicle = ModalRoute.of(context)?.settings.arguments as Vehicle;
    final incidents = vehicle.incidents;

    return BlocProvider(
      create: (context) =>
          serviceLocator<VehicleBloc>()..add(const VehicleLoadEvent()),
      child: BlocConsumer<VehicleBloc, VehicleState>(
        listener: (context, state) {
          if (state is VehicleDeleted) {
            Navigator.of(context).pop();
            showSuccess(context, "Vehicle removed successfully.");
          }
          if (state is VehicleErrorState) {
            showError(context, state.message);
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.blue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              color: AppColors.white,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context
                      .read<VehicleBloc>()
                      .add(DeleteVehicleEvent(vehicle.plate));
                },
                color: AppColors.white,
              ),
            ],
            title: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                vehicle.plate,
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: incidents.isEmpty
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    GeoMap(vehicle: vehicle),
                    const SizedBox(height: 20),
                    if (incidents.isNotEmpty)
                      Text("Incidents",
                          style: Theme.of(context).textTheme.displayMedium),
                    SizedBox(
                      height: 200,
                      child: incidents.isEmpty
                          ? const Center(child: Text('No recorded incident.'))
                          : ListView.builder(
                              itemCount: incidents.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: CachedNetworkImage(
                                    imageUrl: incidents[index].imageUrl,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  title: Text(incidents[index].timestamp),
                                  subtitle: Text(incidents[index].location),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GeoMap extends StatelessWidget {
  final Vehicle vehicle;
  final MapTileLayerController controller = MapTileLayerController();
  final zoomPanBehavior = MapZoomPanBehavior(
    focalLatLng: const MapLatLng(0, 0),
    zoomLevel: 5,
    enableDoubleTapZooming: true,
    enablePinching: true,
  );

  GeoMap({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is VehicleErrorState) {
          return Center(child: Text(state.message));
        } else if (state is VehicleLoaded) {
          return StreamBuilder<Map<String, dynamic>>(
            stream: state.streamSocket.getResponse,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (vehicle.plate == snapshot.data?['plate']) {
                final currentLocation = snapshot.data;
                controller.updateMarkers([0]);
                zoomPanBehavior.focalLatLng = MapLatLng(
                    currentLocation?['latitude'],
                    currentLocation?['longitude']);

                return SfMaps(
                  layers: [
                    MapTileLayer(
                      controller: controller,
                      zoomPanBehavior: zoomPanBehavior,
                      initialFocalLatLng: MapLatLng(
                          currentLocation?['latitude'],
                          currentLocation?['longitude']),
                      // initialZoomLevel: 5,
                      initialMarkersCount: 1,
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      markerBuilder: (BuildContext context, int index) {
                        return MapMarker(
                          latitude: currentLocation?['latitude'],
                          longitude: currentLocation?['longitude'],
                          size: const Size(20, 20),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
