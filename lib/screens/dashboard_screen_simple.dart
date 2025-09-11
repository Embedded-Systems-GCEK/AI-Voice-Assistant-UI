import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/scifi_robot_widget.dart';
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
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<AppStateProvider>(
            builder: (context, provider, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BFFF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00BFFF).withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ONLINE',
                    style: TextStyle(
                      color: const Color(0xFF00BFFF),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      provider.refreshAll();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: const Color(0xFF00BFFF),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
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
        backgroundColor: Colors.grey[900],
        indicatorColor: const Color(0xFF00BFFF).withOpacity(0.2),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard, color: Colors.grey[400]),
            selectedIcon: Icon(Icons.dashboard, color: const Color(0xFF00BFFF)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat, color: Colors.grey[400]),
            selectedIcon: Icon(Icons.chat, color: const Color(0xFF00BFFF)),
            label: 'Conversations',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology, color: Colors.grey[400]),
            selectedIcon: Icon(Icons.psychology, color: const Color(0xFF00BFFF)),
            label: 'AI Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.map, color: Colors.grey[400]),
            selectedIcon: Icon(Icons.map, color: const Color(0xFF00BFFF)),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.people, color: Colors.grey[400]),
            selectedIcon: Icon(Icons.people, color: const Color(0xFF00BFFF)),
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
  RobotState _currentRobotState = RobotState.idle;
  String _status = 'Ready to assist';

  RobotState _getCurrentRobotState() => _currentRobotState;

  void _handleRobotInteraction() {
    // Cycle through different states when tapped
    setState(() {
      switch (_currentRobotState) {
        case RobotState.idle:
          _currentRobotState = RobotState.listening;
          _status = 'Listening to your command...';
          break;
        case RobotState.listening:
          _currentRobotState = RobotState.thinking;
          _status = 'Analyzing your request...';
          break;
        case RobotState.thinking:
          _currentRobotState = RobotState.processing;
          _status = 'Processing data...';
          break;
        case RobotState.processing:
          _currentRobotState = RobotState.speaking;
          _status = 'Generating response...';
          break;
        case RobotState.speaking:
          _currentRobotState = RobotState.idle;
          _status = 'Ready to assist';
          break;
      }
    });

    // Auto-reset to idle after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _currentRobotState = RobotState.idle;
          _status = 'Ready to assist';
        });
      }
    });
  }

  void _simulateRobotState(String state) {
    setState(() {
      switch (state) {
        case 'listening':
          _currentRobotState = RobotState.listening;
          _status = 'Listening to your command...';
          break;
        case 'thinking':
          _currentRobotState = RobotState.thinking;
          _status = 'Analyzing your request...';
          break;
        case 'processing':
          _currentRobotState = RobotState.processing;
          _status = 'Processing data...';
          break;
        case 'speaking':
          _currentRobotState = RobotState.speaking;
          _status = 'Generating response...';
          break;
        case 'idle':
        default:
          _currentRobotState = RobotState.idle;
          _status = 'Ready to assist';
          break;
      }
    });

    // Auto-reset after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentRobotState = RobotState.idle;
          _status = 'Ready to assist';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Color(0xFF001122),
            Colors.black,
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message with sci-fi styling
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF00BFFF), Color(0xFF0080FF)],
                ).createShader(bounds),
                child: Text(
                  'JARVIS INTERFACE',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Advanced AI Assistant • Neural Network Status: ACTIVE',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF00BFFF).withOpacity(0.8),
                      letterSpacing: 1,
                    ),
              ),
              const SizedBox(height: 32),

              // Advanced Sci-Fi Robot Assistant
              Center(
                child: Column(
                  children: [
                    SciFiRobotWidget(
                      size: 280,
                      state: _getCurrentRobotState(),
                      onTap: () => _handleRobotInteraction(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00BFFF).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _status.toUpperCase(),
                        style: TextStyle(
                          color: const Color(0xFF00BFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Sci-Fi Control Panel
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF00BFFF).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings_input_composite,
                          color: const Color(0xFF00BFFF),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'CONTROL INTERFACE',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF00BFFF),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildControlButton(
                          'LISTEN',
                          Icons.mic,
                          const Color(0xFF00FF41),
                          () => _simulateRobotState('listening'),
                        ),
                        _buildControlButton(
                          'ANALYZE',
                          Icons.psychology,
                          const Color(0xFFFFD700),
                          () => _simulateRobotState('thinking'),
                        ),
                        _buildControlButton(
                          'PROCESS',
                          Icons.memory,
                          const Color(0xFFFF4500),
                          () => _simulateRobotState('processing'),
                        ),
                        _buildControlButton(
                          'RESPOND',
                          Icons.record_voice_over,
                          const Color(0xFF9370DB),
                          () => _simulateRobotState('speaking'),
                        ),
                        _buildControlButton(
                          'STANDBY',
                          Icons.power_settings_new,
                          const Color(0xFF00BFFF),
                          () => _simulateRobotState('idle'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Enhanced Statistics Panel
              _buildSciFiCard(
                'SYSTEM METRICS',
                Icons.analytics,
                const Color(0xFF00BFFF),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildMetricItem('USERS', '127', const Color(0xFF00BFFF))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildMetricItem('SESSIONS', '1,429', const Color(0xFF00FF41))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildMetricItem('QUERIES', '847', const Color(0xFFFFD700))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildMetricItem('UPTIME', '99.7%', const Color(0xFF9370DB))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // System Status Panels
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSciFiCard(
                      'NEURAL NETWORKS',
                      Icons.network_check,
                      const Color(0xFF00FF41),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusIndicator('Core Processing', true),
                          _buildStatusIndicator('Voice Recognition', true),
                          _buildStatusIndicator('Natural Language', true),
                          _buildStatusIndicator('Learning Module', false),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSciFiCard(
                      'SENSOR ARRAY',
                      Icons.radar,
                      const Color(0xFFFF4500),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDataRow('Power Level', '89%', Colors.green),
                          _buildDataRow('Temperature', '42.1°C', Colors.orange),
                          _buildDataRow('Network Latency', '12ms', Colors.blue),
                          _buildDataRow('Memory Usage', '67%', Colors.yellow),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Activity Log
              _buildSciFiCard(
                'RECENT ACTIVITY',
                Icons.history,
                const Color(0xFF9370DB),
                Column(
                  children: [
                    _buildActivityItem(
                      'Neural network optimization completed',
                      '2 minutes ago',
                      Icons.psychology,
                      const Color(0xFF00FF41),
                    ),
                    const SizedBox(height: 8),
                    _buildActivityItem(
                      'Voice command processed successfully',
                      '5 minutes ago',
                      Icons.mic,
                      const Color(0xFF00BFFF),
                    ),
                    const SizedBox(height: 8),
                    _buildActivityItem(
                      'System diagnostics completed',
                      '12 minutes ago',
                      Icons.check_circle,
                      const Color(0xFFFFD700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: Colors.black),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _buildSciFiCard(String title, IconData icon, Color accentColor, Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
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
                  color: Colors.grey[400],
                  letterSpacing: 1,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF00FF41) : const Color(0xFFFF4500),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isActive ? const Color(0xFF00FF41) : const Color(0xFFFF4500)).withOpacity(0.6),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 12,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
