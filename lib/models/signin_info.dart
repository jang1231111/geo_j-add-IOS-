import 'package:geo_j/models/log_data.dart';

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
  final String boxName;
  final String deNumber;
  final String deLocation;
  final DateTime datetime;
  final double temperature;
  final int battery;
  // final String bleState;

  A10({
    required this.boxName,
    required this.deNumber,
    required this.datetime,
    required this.deLocation,
    this.temperature = -999,
    this.battery = -999,
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
    String? boxName,
    String? deNumber,
    String? deLocation,
    DateTime? datetime,
    double? temperature,
    int? battery,
  }) {
    return A10(
      boxName: boxName ?? this.boxName,
      deNumber: deNumber ?? this.deNumber,
      deLocation: deLocation ?? this.deLocation,
      datetime: datetime ?? this.datetime,
      temperature: temperature ?? this.temperature,
      battery: battery ?? this.battery,
    );
  }

  @override
  String toString() {
    return 'A10(boxName: $boxName, deNumber: $deNumber, deLocation: $deLocation, datetime: $datetime, temperature: $temperature, battery: $battery)';
  }
}
