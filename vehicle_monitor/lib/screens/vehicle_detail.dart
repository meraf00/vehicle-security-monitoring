import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_monitor/models/incident.dart';
import 'package:vehicle_monitor/models/vehicle.dart';
import 'package:vehicle_monitor/theme/app_colors.dart';

class VehicleScreen extends StatelessWidget {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicle = ModalRoute.of(context)?.settings.arguments as Vehicle;

    final incidents = [
      // Incident(
      //   image: 'assets/images/astu_logo.png',
      //   location: '83874940',
      //   time: '12:00',
      // ),
      // Incident(
      //   image: 'assets/images/astu_logo.png',
      //   location: '83874940',
      //   time: '12:00',
      // ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: AppColors.white,
        ),
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
                                imageUrl: incidents[index].image,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              title: Text(incidents[index].time),
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
    );
  }
}
