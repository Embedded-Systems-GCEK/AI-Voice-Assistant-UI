class SystemStatus {
  final int? id;
  final bool isOnline;
  final bool isListening;
  final bool isProcessing;
  final String status;
  final DateTime timestamp;
  final int? activeUserId;
  final String? currentQuestion;
  final String? currentAnswer;
  final double? systemLoad;
  final int? memoryUsage;

  SystemStatus({
    this.id,
    required this.isOnline,
    required this.isListening,
    required this.isProcessing,
    required this.status,
    required this.timestamp,
    this.activeUserId,
    this.currentQuestion,
    this.currentAnswer,
    this.systemLoad,
    this.memoryUsage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'is_online': isOnline ? 1 : 0,
      'is_listening': isListening ? 1 : 0,
      'is_processing': isProcessing ? 1 : 0,
      'status': status,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'active_user_id': activeUserId,
      'current_question': currentQuestion,
      'current_answer': currentAnswer,
      'system_load': systemLoad,
      'memory_usage': memoryUsage,
    };
  }

  factory SystemStatus.fromMap(Map<String, dynamic> map) {
    return SystemStatus(
      id: map['id'],
      isOnline: (map['is_online'] ?? 0) == 1,
      isListening: (map['is_listening'] ?? 0) == 1,
      isProcessing: (map['is_processing'] ?? 0) == 1,
      status: map['status'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      activeUserId: map['active_user_id'],
      currentQuestion: map['current_question'],
      currentAnswer: map['current_answer'],
      systemLoad: map['system_load']?.toDouble(),
      memoryUsage: map['memory_usage'],
    );
  }

  SystemStatus copyWith({
    int? id,
    bool? isOnline,
    bool? isListening,
    bool? isProcessing,
    String? status,
    DateTime? timestamp,
    int? activeUserId,
    String? currentQuestion,
    String? currentAnswer,
    double? systemLoad,
    int? memoryUsage,
  }) {
    return SystemStatus(
      id: id ?? this.id,
      isOnline: isOnline ?? this.isOnline,
      isListening: isListening ?? this.isListening,
      isProcessing: isProcessing ?? this.isProcessing,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      activeUserId: activeUserId ?? this.activeUserId,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      currentAnswer: currentAnswer ?? this.currentAnswer,
      systemLoad: systemLoad ?? this.systemLoad,
      memoryUsage: memoryUsage ?? this.memoryUsage,
    );
  }
}
