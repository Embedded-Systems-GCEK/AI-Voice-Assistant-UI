import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/conversation.dart';
import '../models/sensor_data.dart';
import '../models/system_status.dart';
import '../services/database_service.dart';

class AppStateProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  List<User> _users = [];
  List<Conversation> _conversations = [];
  SensorData? _currentSensorData;
  SystemStatus? _currentSystemStatus;
  Conversation? _currentConversation;
  Map<String, dynamic> _statistics = {};
  
  bool _isLoading = false;
  String? _error;

  // Getters
  List<User> get users => _users;
  List<Conversation> get conversations => _conversations;
  SensorData? get currentSensorData => _currentSensorData;
  SystemStatus? get currentSystemStatus => _currentSystemStatus;
  Conversation? get currentConversation => _currentConversation;
  Map<String, dynamic> get statistics => _statistics;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AppStateProvider() {
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await refreshAll();
  }

  Future<void> refreshAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.wait([
        refreshUsers(),
        refreshConversations(),
        refreshSensorData(),
        refreshSystemStatus(),
        refreshStatistics(),
      ]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUsers() async {
    try {
      _users = await _databaseService.getUsers();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load users: $e';
      notifyListeners();
    }
  }

  Future<void> refreshConversations() async {
    try {
      _conversations = await _databaseService.getConversations();
      _currentConversation = await _databaseService.getCurrentConversation();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load conversations: $e';
      notifyListeners();
    }
  }

  Future<void> refreshSensorData() async {
    try {
      _currentSensorData = await _databaseService.getLatestSensorData();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load sensor data: $e';
      notifyListeners();
    }
  }

  Future<void> refreshSystemStatus() async {
    try {
      _currentSystemStatus = await _databaseService.getLatestSystemStatus();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load system status: $e';
      notifyListeners();
    }
  }

  Future<void> refreshStatistics() async {
    try {
      _statistics = await _databaseService.getStatistics();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load statistics: $e';
      notifyListeners();
    }
  }

  // User operations
  Future<void> addUser(User user) async {
    try {
      await _databaseService.insertUser(user);
      await refreshUsers();
    } catch (e) {
      _error = 'Failed to add user: $e';
      notifyListeners();
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _databaseService.updateUser(user);
      await refreshUsers();
    } catch (e) {
      _error = 'Failed to update user: $e';
      notifyListeners();
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await _databaseService.deleteUser(userId);
      await refreshUsers();
    } catch (e) {
      _error = 'Failed to delete user: $e';
      notifyListeners();
    }
  }

  // Conversation operations
  Future<void> addConversation(Conversation conversation) async {
    try {
      await _databaseService.insertConversation(conversation);
      await refreshConversations();
      await refreshStatistics();
    } catch (e) {
      _error = 'Failed to add conversation: $e';
      notifyListeners();
    }
  }

  Future<void> setActiveConversation(int conversationId) async {
    try {
      await _databaseService.setActiveConversation(conversationId);
      await refreshConversations();
    } catch (e) {
      _error = 'Failed to set active conversation: $e';
      notifyListeners();
    }
  }

  // Sensor data operations
  Future<void> addSensorData(SensorData sensorData) async {
    try {
      await _databaseService.insertSensorData(sensorData);
      await refreshSensorData();
    } catch (e) {
      _error = 'Failed to add sensor data: $e';
      notifyListeners();
    }
  }

  // System status operations
  Future<void> updateSystemStatus(SystemStatus status) async {
    try {
      await _databaseService.insertSystemStatus(status);
      await refreshSystemStatus();
    } catch (e) {
      _error = 'Failed to update system status: $e';
      notifyListeners();
    }
  }

  // Simulate data for demo purposes
  Future<void> generateDemoData() async {
    try {
      // Create demo user
      final demoUser = User(
        name: 'Demo User',
        email: 'demo@example.com',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        lastInteractionAt: DateTime.now(),
        totalInteractions: 15,
      );
      final userId = await _databaseService.insertUser(demoUser);

      // Create demo conversations
      final conversations = [
        Conversation(
          userId: userId,
          question: 'What is the weather like today?',
          answer: 'Today is partly cloudy with a temperature of 22°C and humidity at 65%.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          confidence: 0.95,
          isActive: true,
        ),
        Conversation(
          userId: userId,
          question: 'How is the battery level?',
          answer: 'The current battery level is at 78% and charging.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          confidence: 0.88,
        ),
        Conversation(
          userId: userId,
          question: 'Where am I located?',
          answer: 'You are currently located in Downtown area, near Central Park.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          confidence: 0.92,
        ),
      ];

      for (final conversation in conversations) {
        await _databaseService.insertConversation(conversation);
      }

      // Create demo sensor data
      final sensorData = SensorData(
        batteryLevel: 78.0,
        temperature: 22.5,
        humidity: 65.0,
        latitude: 40.7829,
        longitude: -73.9654,
        address: '123 Central Park West, New York, NY',
        timestamp: DateTime.now(),
        additionalData: {
          'cpu_usage': '45%',
          'memory_usage': '2.1GB',
          'disk_usage': '67%',
        },
      );
      await _databaseService.insertSensorData(sensorData);

      // Create demo system status
      final systemStatus = SystemStatus(
        isOnline: true,
        isListening: true,
        isProcessing: false,
        status: 'Ready to assist',
        timestamp: DateTime.now(),
        activeUserId: userId,
        currentQuestion: 'What is the weather like today?',
        currentAnswer: 'Today is partly cloudy with a temperature of 22°C and humidity at 65%.',
        systemLoad: 0.45,
        memoryUsage: 2100,
      );
      await _databaseService.insertSystemStatus(systemStatus);

      await refreshAll();
    } catch (e) {
      _error = 'Failed to generate demo data: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
