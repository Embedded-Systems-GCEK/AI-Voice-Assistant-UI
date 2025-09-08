class SensorData {
  final int? id;
  final double? batteryLevel;
  final double? temperature;
  final double? humidity;
  final double? latitude;
  final double? longitude;
  final String? address;
  final DateTime timestamp;
  final Map<String, dynamic>? additionalData;

  SensorData({
    this.id,
    this.batteryLevel,
    this.temperature,
    this.humidity,
    this.latitude,
    this.longitude,
    this.address,
    required this.timestamp,
    this.additionalData,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'battery_level': batteryLevel,
      'temperature': temperature,
      'humidity': humidity,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'additional_data': additionalData != null ? _encodeMap(additionalData!) : null,
    };
  }

  factory SensorData.fromMap(Map<String, dynamic> map) {
    return SensorData(
      id: map['id'],
      batteryLevel: map['battery_level']?.toDouble(),
      temperature: map['temperature']?.toDouble(),
      humidity: map['humidity']?.toDouble(),
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      address: map['address'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      additionalData: map['additional_data'] != null ? _decodeMap(map['additional_data']) : null,
    );
  }

  static String _encodeMap(Map<String, dynamic> map) {
    // Simple JSON-like encoding for additional data
    final pairs = map.entries.map((e) => '"${e.key}":"${e.value}"').join(',');
    return '{$pairs}';
  }

  static Map<String, dynamic> _decodeMap(String encoded) {
    // Simple JSON-like decoding for additional data
    if (encoded.isEmpty || encoded == '{}') return {};
    
    final content = encoded.substring(1, encoded.length - 1);
    final pairs = content.split(',');
    final result = <String, dynamic>{};
    
    for (final pair in pairs) {
      final keyValue = pair.split(':');
      if (keyValue.length == 2) {
        final key = keyValue[0].replaceAll('"', '').trim();
        final value = keyValue[1].replaceAll('"', '').trim();
        result[key] = value;
      }
    }
    
    return result;
  }

  SensorData copyWith({
    int? id,
    double? batteryLevel,
    double? temperature,
    double? humidity,
    double? latitude,
    double? longitude,
    String? address,
    DateTime? timestamp,
    Map<String, dynamic>? additionalData,
  }) {
    return SensorData(
      id: id ?? this.id,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      timestamp: timestamp ?? this.timestamp,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}
