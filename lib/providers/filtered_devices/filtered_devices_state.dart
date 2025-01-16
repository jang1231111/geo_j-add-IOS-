import 'package:geo_j/models/login/signin_info.dart';

class FilteredDevicesState {
  final List<A10> filteredDevices;

  FilteredDevicesState({required this.filteredDevices});

  factory FilteredDevicesState.initial() {
    return FilteredDevicesState(filteredDevices: []);
  }

  @override
  String toString() =>
      'FilteredDevicesState(filteredDevices: $filteredDevices)';

  FilteredDevicesState copyWith({
    List<A10>? filteredDevices,
  }) {
    return FilteredDevicesState(
      filteredDevices: filteredDevices ?? this.filteredDevices,
    );
  }
}
