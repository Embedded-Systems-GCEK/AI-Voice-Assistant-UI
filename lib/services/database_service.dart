import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/conversation.dart';
import '../models/sensor_data.dart';
import '../models/system_status.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize FFI for desktop platforms
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path = join(await getDatabasesPath(), 'ai_voice_assistant.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT,
        avatar_path TEXT,
        created_at INTEGER NOT NULL,
        last_interaction_at INTEGER NOT NULL,
        total_interactions INTEGER DEFAULT 0
      )
    ''');

    // Conversations table
    await db.execute('''
      CREATE TABLE conversations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        confidence REAL,
        context TEXT,
        is_active INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Sensor data table
    await db.execute('''
      CREATE TABLE sensor_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        battery_level REAL,
        temperature REAL,
        humidity REAL,
        latitude REAL,
        longitude REAL,
        address TEXT,
        timestamp INTEGER NOT NULL,
        additional_data TEXT
      )
    ''');

    // System status table
    await db.execute('''
      CREATE TABLE system_status (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        is_online INTEGER NOT NULL,
        is_listening INTEGER NOT NULL,
        is_processing INTEGER NOT NULL,
        status TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        active_user_id INTEGER,
        current_question TEXT,
        current_answer TEXT,
        system_load REAL,
        memory_usage INTEGER,
        FOREIGN KEY (active_user_id) REFERENCES users (id)
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_conversations_user_id ON conversations(user_id)');
    await db.execute('CREATE INDEX idx_conversations_timestamp ON conversations(timestamp)');
    await db.execute('CREATE INDEX idx_sensor_data_timestamp ON sensor_data(timestamp)');
    await db.execute('CREATE INDEX idx_system_status_timestamp ON system_status(timestamp)');
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final maps = await db.query('users', orderBy: 'last_interaction_at DESC');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<User?> getUser(int id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Conversation operations
  Future<int> insertConversation(Conversation conversation) async {
    final db = await database;
    return await db.insert('conversations', conversation.toMap());
  }

  Future<List<Conversation>> getConversations({int? userId, int limit = 50}) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];
    
    if (userId != null) {
      whereClause = 'user_id = ?';
      whereArgs = [userId];
    }
    
    final maps = await db.query(
      'conversations',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    
    return List.generate(maps.length, (i) => Conversation.fromMap(maps[i]));
  }

  Future<Conversation?> getCurrentConversation() async {
    final db = await database;
    final maps = await db.query('conversations', where: 'is_active = ?', whereArgs: [1]);
    if (maps.isNotEmpty) {
      return Conversation.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateConversation(Conversation conversation) async {
    final db = await database;
    return await db.update('conversations', conversation.toMap(), where: 'id = ?', whereArgs: [conversation.id]);
  }

  Future<int> setActiveConversation(int conversationId) async {
    final db = await database;
    // First, deactivate all conversations
    await db.update('conversations', {'is_active': 0});
    // Then activate the specified conversation
    return await db.update('conversations', {'is_active': 1}, where: 'id = ?', whereArgs: [conversationId]);
  }

  Future<int> deleteConversation(int id) async {
    final db = await database;
    return await db.delete('conversations', where: 'id = ?', whereArgs: [id]);
  }

  // Sensor data operations
  Future<int> insertSensorData(SensorData sensorData) async {
    final db = await database;
    return await db.insert('sensor_data', sensorData.toMap());
  }

  Future<List<SensorData>> getSensorData({int limit = 100}) async {
    final db = await database;
    final maps = await db.query('sensor_data', orderBy: 'timestamp DESC', limit: limit);
    return List.generate(maps.length, (i) => SensorData.fromMap(maps[i]));
  }

  Future<SensorData?> getLatestSensorData() async {
    final db = await database;
    final maps = await db.query('sensor_data', orderBy: 'timestamp DESC', limit: 1);
    if (maps.isNotEmpty) {
      return SensorData.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteSensorData(int id) async {
    final db = await database;
    return await db.delete('sensor_data', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> cleanupOldSensorData({int daysToKeep = 30}) async {
    final db = await database;
    final cutoffTime = DateTime.now().subtract(Duration(days: daysToKeep));
    return await db.delete('sensor_data', where: 'timestamp < ?', whereArgs: [cutoffTime.millisecondsSinceEpoch]);
  }

  // System status operations
  Future<int> insertSystemStatus(SystemStatus status) async {
    final db = await database;
    return await db.insert('system_status', status.toMap());
  }

  Future<SystemStatus?> getLatestSystemStatus() async {
    final db = await database;
    final maps = await db.query('system_status', orderBy: 'timestamp DESC', limit: 1);
    if (maps.isNotEmpty) {
      return SystemStatus.fromMap(maps.first);
    }
    return null;
  }

  Future<List<SystemStatus>> getSystemStatusHistory({int limit = 50}) async {
    final db = await database;
    final maps = await db.query('system_status', orderBy: 'timestamp DESC', limit: limit);
    return List.generate(maps.length, (i) => SystemStatus.fromMap(maps[i]));
  }

  Future<int> updateSystemStatus(SystemStatus status) async {
    final db = await database;
    return await db.update('system_status', status.toMap(), where: 'id = ?', whereArgs: [status.id]);
  }

  Future<int> cleanupOldSystemStatus({int daysToKeep = 7}) async {
    final db = await database;
    final cutoffTime = DateTime.now().subtract(Duration(days: daysToKeep));
    return await db.delete('system_status', where: 'timestamp < ?', whereArgs: [cutoffTime.millisecondsSinceEpoch]);
  }

  // General operations
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // Analytics and statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;
    
    final userCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM users')) ?? 0;
    final conversationCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM conversations')) ?? 0;
    final sensorDataCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM sensor_data')) ?? 0;
    
    final todayStart = DateTime.now().subtract(Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute, seconds: DateTime.now().second));
    final todayConversations = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM conversations WHERE timestamp >= ?',
      [todayStart.millisecondsSinceEpoch]
    )) ?? 0;
    
    return {
      'totalUsers': userCount,
      'totalConversations': conversationCount,
      'totalSensorData': sensorDataCount,
      'todayConversations': todayConversations,
    };
  }
}
