class Conversation {
  final int? id;
  final int userId;
  final String question;
  final String answer;
  final DateTime timestamp;
  final double? confidence;
  final String? context;
  final bool isActive;

  Conversation({
    this.id,
    required this.userId,
    required this.question,
    required this.answer,
    required this.timestamp,
    this.confidence,
    this.context,
    this.isActive = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'question': question,
      'answer': answer,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'confidence': confidence,
      'context': context,
      'is_active': isActive ? 1 : 0,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'],
      userId: map['user_id'],
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      confidence: map['confidence']?.toDouble(),
      context: map['context'],
      isActive: (map['is_active'] ?? 0) == 1,
    );
  }

  Conversation copyWith({
    int? id,
    int? userId,
    String? question,
    String? answer,
    DateTime? timestamp,
    double? confidence,
    String? context,
    bool? isActive,
  }) {
    return Conversation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      timestamp: timestamp ?? this.timestamp,
      confidence: confidence ?? this.confidence,
      context: context ?? this.context,
      isActive: isActive ?? this.isActive,
    );
  }
}
