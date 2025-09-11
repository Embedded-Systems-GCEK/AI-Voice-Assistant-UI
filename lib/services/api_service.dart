import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  bool _isOnline = true;
  
  // Getters for URLs from config
  String get baseUrl => AppConfig.apiUrl;
  String get usersUrl => AppConfig.usersUrl;
  String get healthUrl => AppConfig.healthUrl;
  Duration get timeoutDuration => AppConfig.defaultTimeout;

  // Getter for online status
  bool get isOnline => _isOnline;
  ApiService._internal();

  // Headers for JSON requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Example Questions API
  Future<Map<String, dynamic>> getExampleQuestions({String? category}) async {
    // Check if offline mode is enabled and we're offline
    if (AppConfig.enableOfflineMode && !_isOnline) {
      return _getOfflineExampleQuestions(category);
    }

    try {
      String url = '$baseUrl/example-questions';
      if (category != null) {
        url += '?category=${Uri.encodeComponent(category)}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        _isOnline = true; // Mark as online if successful
        return json.decode(response.body);
      } else {
        throw ApiException('Failed to fetch example questions: ${response.statusCode}');
      }
    } on SocketException {
      _isOnline = false;
      if (AppConfig.enableOfflineMode) {
        return _getOfflineExampleQuestions(category);
      }
      throw ApiException('No internet connection');
    } on http.ClientException {
      _isOnline = false;
      if (AppConfig.enableOfflineMode) {
        return _getOfflineExampleQuestions(category);
      }
      throw ApiException('Failed to connect to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      _isOnline = false;
      if (AppConfig.enableOfflineMode) {
        return _getOfflineExampleQuestions(category);
      }
      throw ApiException('Error fetching example questions: $e');
    }
  }

  // Offline fallback for example questions
  Map<String, dynamic> _getOfflineExampleQuestions(String? category) {
    final questions = AppConfig.defaultExampleQuestions['questions'] as List;
    
    if (category != null) {
      final filteredQuestions = questions
          .where((q) => q['category'].toString().toLowerCase() == category.toLowerCase())
          .toList();
      return {
        'questions': filteredQuestions,
        'categories': AppConfig.defaultExampleQuestions['categories'],
        'offline': true,
      };
    }
    
    return {
      ...AppConfig.defaultExampleQuestions,
      'offline': true,
    };
  }

  // Ask Assistant API
  Future<Map<String, dynamic>> askAssistant({
    required String question,
    String? userId,
  }) async {
    // Check if offline mode is enabled and we're offline
    if (AppConfig.enableOfflineMode && !_isOnline) {
      return _getOfflineAssistantResponse(question, userId);
    }

    try {
      final requestBody = {
        'question': question,
        if (userId != null) 'user_id': userId,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/ask'),
        headers: _headers,
        body: json.encode(requestBody),
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        _isOnline = true; // Mark as online if successful
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw ApiException(errorBody['error'] ?? 'Failed to get response from assistant');
      }
    } on SocketException {
      _isOnline = false;
      if (AppConfig.enableOfflineMode) {
        return _getOfflineAssistantResponse(question, userId);
      }
      throw ApiException('No internet connection');
    } on http.ClientException {
      _isOnline = false;
      if (AppConfig.enableOfflineMode) {
        return _getOfflineAssistantResponse(question, userId);
      }
      throw ApiException('Failed to connect to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      _isOnline = false;
      if (AppConfig.enableOfflineMode) {
        return _getOfflineAssistantResponse(question, userId);
      }
      throw ApiException('Error asking assistant: $e');
    }
  }

  // Offline fallback for assistant responses
  Map<String, dynamic> _getOfflineAssistantResponse(String question, String? userId) {
    final responses = {
      'weather': 'I\'m currently offline and cannot access real-time weather data. Please check your internet connection for live weather updates.',
      'battery': 'Battery information is not available in offline mode. Please reconnect to get real-time system status.',
      'location': 'Location services are limited in offline mode. Please check your internet connection for accurate location data.',
      'help': 'I\'m currently running in offline mode with limited functionality. I can still help with basic questions, but real-time data and advanced features require an internet connection.',
      'default': 'I\'m currently offline and have limited capabilities. Please check your internet connection to access the full range of assistant features.'
    };

    String response = responses['default']!;
    final lowerQuestion = question.toLowerCase();
    
    if (lowerQuestion.contains('weather') || lowerQuestion.contains('temperature')) {
      response = responses['weather']!;
    } else if (lowerQuestion.contains('battery') || lowerQuestion.contains('power')) {
      response = responses['battery']!;
    } else if (lowerQuestion.contains('location') || lowerQuestion.contains('where')) {
      response = responses['location']!;
    } else if (lowerQuestion.contains('help') || lowerQuestion.contains('what can you')) {
      response = responses['help']!;
    }

    return {
      'question': question,
      'response': response,
      'confidence_score': 0.8,
      'response_time_ms': 100,
      'timestamp': DateTime.now().toIso8601String(),
      'user_id': userId,
      'offline': true,
    };
  }

  // Get User Conversation History
  Future<Map<String, dynamic>> getUserConversation({
    required String userId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final url = '$baseUrl/conversation/$userId?limit=$limit&offset=$offset';
      
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw ApiException(errorBody['error'] ?? 'Failed to fetch conversation history');
      }
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException {
      throw ApiException('Failed to connect to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error fetching conversation: $e');
    }
  }

  // Get Assistant Status
  Future<Map<String, dynamic>> getAssistantStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/assistant/status'),
        headers: _headers,
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ApiException('Failed to fetch assistant status: ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException {
      throw ApiException('Failed to connect to server');
    } catch (e) {
      throw ApiException('Error fetching assistant status: $e');
    }
  }

  // Reset Assistant
  Future<Map<String, dynamic>> resetAssistant() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/assistant/reset'),
        headers: _headers,
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw ApiException(errorBody['error'] ?? 'Failed to reset assistant');
      }
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException {
      throw ApiException('Failed to connect to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error resetting assistant: $e');
    }
  }

  // Create User (using existing backend API)
  Future<Map<String, dynamic>> createUser({
    required String username,
    required String email,
  }) async {
    try {
      final requestBody = {
        'username': username,
        'email': email,
      };

      final response = await http.post(
        Uri.parse('$usersUrl'),
        headers: _headers,
        body: json.encode(requestBody),
      ).timeout(timeoutDuration);

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw ApiException(errorBody['error'] ?? 'Failed to create user');
      }
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException {
      throw ApiException('Failed to connect to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error creating user: $e');
    }
  }

  // Get Users
  Future<Map<String, dynamic>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$usersUrl'),
        headers: _headers,
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ApiException('Failed to fetch users: ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException {
      throw ApiException('Failed to connect to server');
    } catch (e) {
      throw ApiException('Error fetching users: $e');
    }
  }

  // Health Check
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$healthUrl'),
        headers: _headers,
      ).timeout(AppConfig.healthCheckTimeout);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => 'ApiException: $message';
}

// Models for API responses
class ExampleQuestion {
  final int id;
  final String category;
  final String question;
  final String description;

  ExampleQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.description,
  });

  factory ExampleQuestion.fromJson(Map<String, dynamic> json) {
    return ExampleQuestion(
      id: json['id'],
      category: json['category'],
      question: json['question'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'question': question,
      'description': description,
    };
  }
}

class AssistantResponse {
  final String question;
  final String response;
  final double? confidenceScore;
  final int? responseTimeMs;
  final DateTime timestamp;
  final String? userId;

  AssistantResponse({
    required this.question,
    required this.response,
    this.confidenceScore,
    this.responseTimeMs,
    required this.timestamp,
    this.userId,
  });

  factory AssistantResponse.fromJson(Map<String, dynamic> json) {
    return AssistantResponse(
      question: json['question'],
      response: json['response'],
      confidenceScore: json['confidence_score']?.toDouble(),
      responseTimeMs: json['response_time_ms'],
      timestamp: DateTime.parse(json['timestamp']),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'response': response,
      'confidence_score': confidenceScore,
      'response_time_ms': responseTimeMs,
      'timestamp': timestamp.toIso8601String(),
      'user_id': userId,
    };
  }
}
