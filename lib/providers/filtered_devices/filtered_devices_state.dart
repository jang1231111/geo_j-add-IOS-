import 'package:geo_j/models/signin_info.dart';

class FilteredDevicesState {
  final List<Device> filteredDevices;

  FilteredDevicesState({required this.filteredDevices});

  factory FilteredDevicesState.initial() {
    return FilteredDevicesState(filteredDevices: []);
  }

  @override
  String toString() =>
      'FilteredDevicesState(filteredDevices: $filteredDevices)';

  FilteredDevicesState copyWith({
    List<Device>? filteredDevices,
  }) {
    return FilteredDevicesState(
      filteredDevices: filteredDevices ?? this.filteredDevices,
    );
  }
}
