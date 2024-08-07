import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/providers/device_filter/device_filter_provider.dart';
import 'package:geo_j/providers/device_search/device_search_provider.dart';
import 'package:geo_j/providers/filtered_devices/filtered_devices_state.dart';
import 'package:geo_j/providers/signin/signin_provider.dart';

class FilteredDevicesProvider {
  final DeviceFilterProvider deviceFilterProvider;
  final DeviceSearchProvider deviceSearchProvider;
  final SigninProvider signinProvider;

  FilteredDevicesProvider(
      {required this.deviceFilterProvider,
      required this.deviceSearchProvider,
      required this.signinProvider});

  FilteredDevicesState get state {
    List<A10> _filteredDevices;
    List<A10> _devices = signinProvider.state.signinInfo.devices;

    switch (deviceFilterProvider.state.filter) {
      case Filter.active:
        _filteredDevices = _devices.where((A10 device) {
          return device.transportState != 1;
        }).toList();
        break;
      case Filter.completed:
        _filteredDevices = _devices.where((A10 device) {
          return device.transportState == 1;
        }).toList();
        break;
      case Filter.all:
        _filteredDevices = _devices;
        break;
    }

    if (deviceSearchProvider.state.searchTerm.isNotEmpty) {
      _filteredDevices = _filteredDevices
          .where((A10 device) => device.boxName
              .toLowerCase()
              .contains(deviceSearchProvider.state.searchTerm))
          .toList();
    }

    // print('_filteredDevices $_filteredDevices');

    return FilteredDevicesState(filteredDevices: _filteredDevices);
  }
}
