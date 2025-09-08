import 'package:flutter/material.dart';
import '../models/system_status.dart';
import '../themes/catppuccin_theme.dart';

class StatusCard extends StatelessWidget {
  final SystemStatus? status;

  const StatusCard({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: CatppuccinColors.blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'System Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (status == null)
              Text(
                'No status data available',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CatppuccinColors.subtext1,
                    ),
              )
            else
              Column(
                children: [
                  _buildStatusRow(
                    context,
                    'Online',
                    status!.isOnline,
                    Icons.cloud,
                  ),
                  const SizedBox(height: 8),
                  _buildStatusRow(
                    context,
                    'Listening',
                    status!.isListening,
                    Icons.mic,
                  ),
                  const SizedBox(height: 8),
                  _buildStatusRow(
                    context,
                    'Processing',
                    status!.isProcessing,
                    Icons.psychology,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: CatppuccinColors.subtext1,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          status!.status,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: CatppuccinColors.subtext1,
                              ),
                        ),
                      ),
                    ],
                  ),
                  if (status!.systemLoad != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.memory,
                          size: 16,
                          color: CatppuccinColors.subtext1,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Load: ${(status!.systemLoad! * 100).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: CatppuccinColors.subtext1,
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

  Widget _buildStatusRow(
    BuildContext context,
    String label,
    bool isActive,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isActive ? CatppuccinColors.green : CatppuccinColors.red,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? CatppuccinColors.green : CatppuccinColors.red,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
