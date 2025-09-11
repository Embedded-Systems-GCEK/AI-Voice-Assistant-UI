import 'package:flutter/material.dart';
import '../widgets/scifi_robot_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  RobotState _robotState = RobotState.idle;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Voice Assistant'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF001122), Colors.black],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'JARVIS INTERFACE',
                style: TextStyle(
                  color: Color(0xFF00BFFF),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),
              SciFiRobotWidget(
                size: 200,
                state: _robotState,
                onTap: _handleRobotTap,
              ),
              const SizedBox(height: 20),
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
                  _getStatusText(),
                  style: const TextStyle(
                    color: Color(0xFF00BFFF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (_robotState) {
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
}
