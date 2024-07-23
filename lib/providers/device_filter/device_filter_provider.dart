import 'package:flutter/material.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/providers/device_filter/device_filter_state.dart';

class DeviceFilterProvider with ChangeNotifier {
  DeviceFilterState _state = DeviceFilterState.initial();
  DeviceFilterState get state => _state;

  void changeFilter(Filter newFilter) {
    _state = _state.copyWith(filter: newFilter);
    notifyListeners();
  }
}
