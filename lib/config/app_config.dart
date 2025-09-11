import 'package:flutter/foundation.dart';

class AppConfig {
  // API Configuration
  static const String _devApiUrl = 'http://localhost:5000';
  static const String _prodApiUrl = 'https://your-api-domain.com'; // Replace with actual production URL
  
  // Environment detection
  static bool get isDebug => kDebugMode;
  static bool get isRelease => kReleaseMode;
  
  // API URLs
  static String get apiBaseUrl => isDebug ? _devApiUrl : _prodApiUrl;
  static String get apiUrl => '$apiBaseUrl/api';
  static String get usersUrl => '$apiBaseUrl/users';
  static String get healthUrl => '$apiBaseUrl/health';
  
  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration healthCheckTimeout = Duration(seconds: 5);
  
  // Feature flags
  static const bool enableOfflineMode = true;
  static const bool enableDemoData = true;
  static const bool enableApiHealthCheck = true;
  
  // App metadata
  static const String appName = 'AI Voice Assistant';
  static const String appVersion = '1.0.0';
  
  // Default values for offline mode
  static const Map<String, dynamic> defaultExampleQuestions = {
    'questions': [
      {
        'id': 1,
        'category': 'General',
        'question': 'What can you help me with?',
        'description': 'Learn about the assistant capabilities'
      },
      {
        'id': 2,
        'category': 'Weather',
        'question': 'What is the weather like today?',
        'description': 'Get current weather information'
      },
      {
        'id': 3,
        'category': 'System',
        'question': 'How is the battery level?',
        'description': 'Check device battery status'
      },
      {
        'id': 4,
        'category': 'Location',
        'question': 'Where am I located?',
        'description': 'Get current location information'
      }
    ],
    'categories': ['General', 'Weather', 'System', 'Location']
  };
}