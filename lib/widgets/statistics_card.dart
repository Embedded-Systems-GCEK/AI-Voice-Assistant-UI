import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../themes/catppuccin_theme.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        final stats = provider.statistics;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      color: CatppuccinColors.yellow,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Statistics',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (stats.isEmpty)
                  Text(
                    'No statistics available',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CatppuccinColors.subtext1,
                        ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 600;
                      
                      if (isNarrow) {
                        // Two rows layout for narrow screens
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    context,
                                    'Users',
                                    stats['totalUsers']?.toString() ?? '0',
                                    Icons.people,
                                    CatppuccinColors.blue,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatItem(
                                    context,
                                    'Chats',
                                    stats['totalConversations']?.toString() ?? '0',
                                    Icons.chat,
                                    CatppuccinColors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    context,
                                    'Today',
                                    stats['todayConversations']?.toString() ?? '0',
                                    Icons.today,
                                    CatppuccinColors.mauve,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatItem(
                                    context,
                                    'Data',
                                    stats['totalSensorData']?.toString() ?? '0',
                                    Icons.sensors,
                                    CatppuccinColors.peach,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        // Single row layout for wider screens
                        return Row(
                          children: [
                            Expanded(
                              child: _buildStatItem(
                                context,
                                'Total Users',
                                stats['totalUsers']?.toString() ?? '0',
                                Icons.people,
                                CatppuccinColors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatItem(
                                context,
                                'Conversations',
                                stats['totalConversations']?.toString() ?? '0',
                                Icons.chat,
                                CatppuccinColors.green,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatItem(
                                context,
                                'Today',
                                stats['todayConversations']?.toString() ?? '0',
                                Icons.today,
                                CatppuccinColors.mauve,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatItem(
                                context,
                                'Data Points',
                                stats['totalSensorData']?.toString() ?? '0',
                                Icons.sensors,
                                CatppuccinColors.peach,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CatppuccinColors.surface1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: CatppuccinColors.subtext1,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
