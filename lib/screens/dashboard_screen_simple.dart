import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../themes/catppuccin_theme.dart';
import '../widgets/robot_assistant_widget.dart';
import 'map_screen.dart';
import 'conversation_screen.dart';
import 'users_screen.dart';
import 'ai_chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Voice Assistant'),
        actions: [
          Consumer<AppStateProvider>(
            builder: (context, provider, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Online'),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      // provider.refreshAll();
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _DashboardTab(),
          ConversationScreen(),
          AiChatScreen(),
          MapScreen(),
          UsersScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Conversations',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology),
            label: 'AI Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}

class _DashboardTab extends StatefulWidget {
  const _DashboardTab();

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  bool _isListening = false;
  bool _isProcessing = false;
  String _status = 'Ready to assist';

  void _simulateRobotState(String state) {
    setState(() {
      switch (state) {
        case 'listening':
          _isListening = true;
          _isProcessing = false;
          _status = 'Listening to your command...';
          
          // Auto-reset after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _isListening = false;
                _status = 'Ready to assist';
              });
            }
          });
          break;
        case 'processing':
          _isListening = false;
          _isProcessing = true;
          _status = 'Processing your request...';
          
          // Auto-reset after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _isProcessing = false;
                _status = 'Task completed!';
                
                // Final reset after 1 second
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    setState(() {
                      _status = 'Ready to assist';
                    });
                  }
                });
              });
            }
          });
          break;
        case 'idle':
          _isListening = false;
          _isProcessing = false;
          _status = 'Ready to assist';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Here\'s what\'s happening with your AI assistant',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),

            // Robot Assistant - Jarvis-like visual
            Center(
              child: RobotAssistantWidget(
                isOnline: true,
                isListening: _isListening,
                isProcessing: _isProcessing,
                status: _status,
              ),
            ),
            const SizedBox(height: 24),

            // Robot control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Simulate listening mode
                    _simulateRobotState('listening');
                  },
                  icon: const Icon(Icons.mic),
                  label: const Text('Listen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CatppuccinColors.yellow.withOpacity(0.2),
                    foregroundColor: CatppuccinColors.yellow,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Simulate processing mode
                    _simulateRobotState('processing');
                  },
                  icon: const Icon(Icons.psychology),
                  label: const Text('Process'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CatppuccinColors.mauve.withOpacity(0.2),
                    foregroundColor: CatppuccinColors.mauve,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Reset to idle
                    _simulateRobotState('idle');
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CatppuccinColors.blue.withOpacity(0.2),
                    foregroundColor: CatppuccinColors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Simple statistics card
            Card(
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
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            context,
                            'Users',
                            '5',
                            Icons.people,
                            CatppuccinColors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            'Chats',
                            '12',
                            Icons.chat,
                            CatppuccinColors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            'Today',
                            '3',
                            Icons.today,
                            CatppuccinColors.mauve,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            'Data',
                            '28',
                            Icons.sensors,
                            CatppuccinColors.peach,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // System status cards
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                          _buildStatusRow(context, 'Online', true, Icons.cloud),
                          const SizedBox(height: 8),
                          _buildStatusRow(context, 'Listening', true, Icons.mic),
                          const SizedBox(height: 8),
                          _buildStatusRow(context, 'Processing', false, Icons.psychology),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
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
                          _buildSensorRow(context, Icons.battery_full, 'Battery', '78%'),
                          const SizedBox(height: 8),
                          _buildSensorRow(context, Icons.thermostat, 'Temperature', '22.5°C'),
                          const SizedBox(height: 8),
                          _buildSensorRow(context, Icons.water_drop, 'Humidity', '65%'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Simple recent activity card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history,
                          color: CatppuccinColors.mauve,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Recent Activity',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: CatppuccinColors.blue,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: const Text('Demo User asked about weather'),
                      subtitle: const Text('2 minutes ago'),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: CatppuccinColors.green,
                        child: const Icon(Icons.sensors, color: Colors.white),
                      ),
                      title: const Text('Sensor data updated'),
                      subtitle: const Text('5 minutes ago'),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
        mainAxisSize: MainAxisSize.min,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: CatppuccinColors.subtext1,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context, String label, bool isActive, IconData icon) {
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

  Widget _buildSensorRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: CatppuccinColors.blue,
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
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
