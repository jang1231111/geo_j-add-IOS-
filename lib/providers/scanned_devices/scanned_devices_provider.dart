import 'package:geo_j/providers/scanned_devices/scanned_devices_state.dart';

class ScannedDevicesProvider {
  ScannedDeviecsState _state = ScannedDeviecsState.initial();
  ScannedDeviecsState get state => _state;
}

class DeviceSearchProvider with ChangeNotifier {
  DeviceSearchState _state = DeviceSearchState.initial();
  DeviceSearchState get state => _state;

  void setSearchTerm(String newSearchTerm) {
    _state = _state.copyWith(searchTerm: newSearchTerm);
    notifyListeners();
  }
}
