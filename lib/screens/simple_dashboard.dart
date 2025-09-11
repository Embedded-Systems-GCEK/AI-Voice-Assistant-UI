import 'package:flutter/material.dart';
import '../widgets/scifi_robot_widget.dart';
import '../services/api_service.dart';
import 'conversation_screen.dart';
import 'ai_chat_screen.dart';
import 'map_screen.dart';
import 'users_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  RobotState _robotState = RobotState.idle;
  bool _isOnline = true;
  final ApiService _apiService = ApiService();

  // List of screens for navigation
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _JarvisHomeScreen(
        robotState: _robotState, 
        onRobotTap: _handleRobotTap,
        isOnline: _isOnline,
      ), // Main JARVIS screen
      const ConversationScreen(),
      const AiChatScreen(),
      const MapScreen(),
      const UsersScreen(),
    ];
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final isHealthy = await _apiService.checkHealth();
    if (mounted && isHealthy != _isOnline) {
      setState(() {
        _isOnline = isHealthy;
        _screens[0] = _JarvisHomeScreen(
          robotState: _robotState, 
          onRobotTap: _handleRobotTap,
          isOnline: _isOnline,
        );
      });
    }
  }

  void _handleRobotTap() {
    setState(() {
      switch (_robotState) {
        case RobotState.idle:
          _robotState = RobotState.listening;
          break;
        case RobotState.listening:
          _robotState = RobotState.thinking;
          break;
        case RobotState.thinking:
          _robotState = RobotState.processing;
          break;
        case RobotState.processing:
          _robotState = RobotState.speaking;
          break;
        case RobotState.speaking:
          _robotState = RobotState.idle;
          break;
      }
    });
    // Check connectivity when user interacts
    _checkConnectivity();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Update the JARVIS screen with new state when switching back to it
      if (index == 0) {
        _screens[0] = _JarvisHomeScreen(
          robotState: _robotState, 
          onRobotTap: _handleRobotTap,
          isOnline: _isOnline,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF00BFFF),
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'JARVIS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Conversations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'AI Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}

// Separate widget for the JARVIS home screen
class _JarvisHomeScreen extends StatelessWidget {
  final RobotState robotState;
  final VoidCallback onRobotTap;
  final bool isOnline;

  const _JarvisHomeScreen({
    required this.robotState,
    required this.onRobotTap,
    required this.isOnline,
  });

  String _getStatusText() {
    switch (robotState) {
      case RobotState.idle:
        return 'READY TO ASSIST';
      case RobotState.listening:
        return 'LISTENING TO COMMAND...';
      case RobotState.thinking:
        return 'ANALYZING REQUEST...';
      case RobotState.processing:
        return 'PROCESSING DATA...';
      case RobotState.speaking:
        return 'GENERATING RESPONSE...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color(0xFF001122), Colors.black],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.android,
                    color: Color(0xFF00BFFF),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'JARVIS INTERFACE',
                    style: TextStyle(
                      color: Color(0xFF00BFFF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (isOnline ? Colors.green : Colors.orange).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (isOnline ? Colors.green : Colors.orange).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: isOnline ? Colors.green : Colors.orange,
                          size: 8,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isOnline ? 'ONLINE' : 'OFFLINE',
                          style: TextStyle(
                            color: isOnline ? Colors.green : Colors.orange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Welcome Text
                        const Text(
                          'ADVANCED AI ASSISTANT',
                          style: TextStyle(
                            color: Color(0xFF00BFFF),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'NEURAL NETWORK STATUS: ACTIVE',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Robot Widget - Made smaller
                        SciFiRobotWidget(
                          size: 180,
                          state: robotState,
                          onTap: onRobotTap,
                        ),
                        const SizedBox(height: 20),

                        // Status Display
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF00BFFF).withOpacity(0.4),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00BFFF).withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Text(
                            _getStatusText(),
                            style: const TextStyle(
                              color: Color(0xFF00BFFF),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Quick Actions
                        const Text(
                          'TAP ROBOT TO INTERACT',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 9,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isOnline 
                            ? 'USE NAVIGATION BELOW TO ACCESS OTHER FEATURES'
                            : 'LIMITED FEATURES AVAILABLE IN OFFLINE MODE',
                          style: TextStyle(
                            color: isOnline ? Colors.white38 : Colors.orange.withOpacity(0.8),
                            fontSize: 8,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
