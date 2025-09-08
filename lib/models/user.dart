class User {
  final int? id;
  final String name;
  final String? email;
  final String? avatarPath;
  final DateTime createdAt;
  final DateTime lastInteractionAt;
  final int totalInteractions;

  User({
    this.id,
    required this.name,
    this.email,
    this.avatarPath,
    required this.createdAt,
    required this.lastInteractionAt,
    this.totalInteractions = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_path': avatarPath,
      'created_at': createdAt.millisecondsSinceEpoch,
      'last_interaction_at': lastInteractionAt.millisecondsSinceEpoch,
      'total_interactions': totalInteractions,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'],
      avatarPath: map['avatar_path'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      lastInteractionAt: DateTime.fromMillisecondsSinceEpoch(map['last_interaction_at']),
      totalInteractions: map['total_interactions'] ?? 0,
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? avatarPath,
    DateTime? createdAt,
    DateTime? lastInteractionAt,
    int? totalInteractions,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
      lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
      totalInteractions: totalInteractions ?? this.totalInteractions,
    );
  }
}
