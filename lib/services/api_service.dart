import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Headers for JSON requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Example Questions API
  Future<Map<String, dynamic>> getExampleQuestions({String? category}) async {
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
        return json.decode(response.body);
      } else {
        throw ApiException('Failed to fetch example questions: ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException {
      throw ApiException('Failed to connect to server');
    } catch (e) {
      throw ApiException('Error fetching example questions: $e');
    }
  }

  // Ask Assistant API
  Future<Map<String, dynamic>> askAssistant({
    required String question,
    String? userId,
  }) async {
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
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw ApiException(errorBody['error'] ?? 'Failed to get response from assistant');
      }
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException {
      throw ApiException('Failed to connect to server');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error asking assistant: $e');
    }
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
        Uri.parse('http://localhost:5000/users'),
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
        Uri.parse('http://localhost:5000/users'),
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
        Uri.parse('http://localhost:5000/health'),
        headers: _headers,
      ).timeout(const Duration(seconds: 5));

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
