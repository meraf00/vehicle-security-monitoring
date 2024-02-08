import 'package:flutter/material.dart';
import 'package:vehicle_monitor/models/vehicle.dart';
import 'package:vehicle_monitor/theme/app_colors.dart';

class VehicleScreen extends StatelessWidget {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      Vehicle(plate: '5X472', location: '83874940'),
      Vehicle(plate: '5X472', location: '83874940'),
      Vehicle(plate: '5X472', location: '83874940'),
      Vehicle(plate: '5X472', location: '83874940'),
      Vehicle(plate: '5X472', location: '83874940'),
      Vehicle(plate: '5X472', location: '83874940'),
      Vehicle(plate: '5X472', location: '83874940'),
      Vehicle(plate: '5X472', location: '83874940'),
      Vehicle(plate: '5X472', location: '83874940', status: Status.connected),
      Vehicle(plate: '5X472', location: '83874940', status: Status.connected),
      Vehicle(plate: '5X472', location: '83874940', status: Status.connected),
      Vehicle(plate: '5X472', location: '83874940', status: Status.connected),
    ];

    items.sort(
      (a, b) => (a.status < b.status) ? -1 : 1,
    );

    return Scaffold(
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
              stops: [0.9, 1.0], // 10% purple, 80% transparent, 10% purple
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () => {
                  Navigator.pushNamed(context, '/about'),
                },

                contentPadding: const EdgeInsets.all(9.0),

                horizontalTitleGap: 30,

                //
                leading: CircleAvatar(
                  backgroundColor: items[index].status == Status.disconnected
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
                        child: Text('Delete'),
                      ),
                    ];
                  },
                ),

                //
                title: Text(
                  items[index].plate,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                //
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: items[index].status == Status.disconnected
                          ? AppColors.red
                          : Colors.green,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    items[index].status == Status.disconnected
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
        ),
      ),
    );
  }
}
