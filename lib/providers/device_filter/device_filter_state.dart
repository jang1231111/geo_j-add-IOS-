import 'package:geo_j/models/signin_info.dart';

class DeviceFilterState {
  final Filter filter;

  DeviceFilterState({required this.filter});

  factory DeviceFilterState.initial() {
    return DeviceFilterState(filter: Filter.all);
  }

  @override
  String toString() => 'DeviceFilter(filter: $filter)';

  DeviceFilterState copyWith({
    Filter? filter,
  }) {
    return DeviceFilterState(
      filter: filter ?? this.filter,
    );
  }
}
