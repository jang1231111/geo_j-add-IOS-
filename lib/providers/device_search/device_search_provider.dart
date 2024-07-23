import 'package:flutter/material.dart';
import 'package:geo_j/providers/device_search/devife_search_state.dart';

class DeviceSearchProvider with ChangeNotifier {
  DeviceSearchState _state = DeviceSearchState.initial();
  DeviceSearchState get state => _state;

  void setSearchTerm(String newSearchTerm) {
    _state = _state.copyWith(searchTerm: newSearchTerm);
    notifyListeners();
  }
}
