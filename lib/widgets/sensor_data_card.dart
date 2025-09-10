import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../themes/catppuccin_theme.dart';

class SensorDataCard extends StatelessWidget {
  final SensorData? sensorData;

  const SensorDataCard({super.key, this.sensorData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sensors,
                  color: CatppuccinColors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Sensor Data',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (sensorData == null)
              Text(
                'No sensor data available',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CatppuccinColors.subtext1,
                    ),
              )
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (sensorData!.batteryLevel != null)
                    _buildSensorRow(
                      context,
                      Icons.battery_full,
                      'Battery',
                      '${sensorData!.batteryLevel!.toStringAsFixed(0)}%',
                      _getBatteryColor(sensorData!.batteryLevel!),
                    ),
                  if (sensorData!.temperature != null) ...[
                    const SizedBox(height: 8),
                    _buildSensorRow(
                      context,
                      Icons.thermostat,
                      'Temperature',
                      '${sensorData!.temperature!.toStringAsFixed(1)}°C',
                      CatppuccinColors.peach,
                    ),
                  ],
                  if (sensorData!.humidity != null) ...[
                    const SizedBox(height: 8),
                    _buildSensorRow(
                      context,
                      Icons.water_drop,
                      'Humidity',
                      '${sensorData!.humidity!.toStringAsFixed(0)}%',
                      CatppuccinColors.blue,
                    ),
                  ],
                  if (sensorData!.address != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: CatppuccinColors.red,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            sensorData!.address!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: CatppuccinColors.subtext1,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: color,
              ),
        ),
      ],
    );
  }

  Color _getBatteryColor(double level) {
    if (level > 50) return CatppuccinColors.green;
    if (level > 20) return CatppuccinColors.yellow;
    return CatppuccinColors.red;
  }
}
