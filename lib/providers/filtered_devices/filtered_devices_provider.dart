import 'package:flutter/material.dart';
import 'package:geo_j/models/login/signin_info.dart';
import 'package:geo_j/providers/device_filter/device_filter_provider.dart';
import 'package:geo_j/providers/device_search/device_search_provider.dart';
import 'package:geo_j/providers/filtered_devices/filtered_devices_state.dart';
import 'package:geo_j/providers/signin/signin_provider.dart';

class FilteredDevicesProvider extends ChangeNotifier {
  final DeviceFilterProvider deviceFilterProvider;
  final DeviceSearchProvider deviceSearchProvider;
  final SigninProvider signinProvider;

  List<A10> _filteredDevices = [];

  FilteredDevicesProvider({
    required this.deviceFilterProvider,
    required this.deviceSearchProvider,
    required this.signinProvider,
  }) {
    _filteredDevices = signinProvider.state.signinInfo.devices
        .where((device) => device.scanned)
        .toList();
  }

  FilteredDevicesState get state =>
      FilteredDevicesState(filteredDevices: _filteredDevices);
}
