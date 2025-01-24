class LogData {
  final double temperature;
  final double humidity;
  final DateTime timeStamp;

  LogData({
    required this.temperature,
    required this.humidity,
    required this.timeStamp,
  });

  @override
  String toString() =>
      'LogData(temperature: $temperature, humidity: $humidity, timeStamp: $timeStamp)';

  LogData copyWith({
    double? temperature,
    double? humidity,
    DateTime? timeStamp,
  }) {
    return LogData(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }
}

