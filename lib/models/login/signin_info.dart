// ignore_for_file: public_member_api_docs, sort_constructors_first
enum Filter {
  all,
  active,
  completed,
}

class SigninInfo {
  final List<A10> devices;

  factory SigninInfo.initial() {
    return SigninInfo(devices: []);
  }

  SigninInfo({required this.devices});

  @override
  String toString() => 'SigninInfo(devices: $devices)';

  SigninInfo copyWith({
    List<A10>? devices,
  }) {
    return SigninInfo(
      devices: devices ?? this.devices,
    );
  }
}

class A10 {
  final DateTime? startTime;
  final String boxName;
  final String deNumber;
  final String deLocation;
  final DateTime datetime;
  final double temperature;
  final int battery;
  final bool scanned;
  // final String bleState;

  A10({
    required this.boxName,
    required this.deNumber,
    required this.deLocation,
    required this.datetime,
    this.startTime,
    this.temperature = -99,
    this.battery = -999,
    this.scanned = false,
  });

  factory A10.fromJson(Map<String, dynamic> json) {
    return A10(
      boxName: json['box_name'],
      deNumber: json['de_number'],
      deLocation: json['de_location'],
      datetime: DateTime.parse(json['datetime']),
    );
  }

  A10 copyWith({
    DateTime? startTime,
    String? boxName,
    String? deNumber,
    String? deLocation,
    DateTime? datetime,
    double? temperature,
    int? battery,
    bool? scanned,
  }) {
    return A10(
      startTime: startTime ?? this.startTime,
      boxName: boxName ?? this.boxName,
      deNumber: deNumber ?? this.deNumber,
      deLocation: deLocation ?? this.deLocation,
      datetime: datetime ?? this.datetime,
      temperature: temperature ?? this.temperature,
      battery: battery ?? this.battery,
      scanned: scanned ?? this.scanned,
    );
  }

  @override
  String toString() {
    return 'A10(startTime: $startTime, boxName: $boxName, deNumber: $deNumber, deLocation: $deLocation, datetime: $datetime, temperature: $temperature, battery: $battery, scanned: $scanned)';
  }
}
