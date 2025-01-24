import 'package:flutter/material.dart';
import 'package:geo_j/providers/connection_provider/connection_state.dart';

class ConnectionProvider extends ChangeNotifier {
  ConnectingState _state = ConnectingState.initial();
  ConnectingState get state => _state;

  void connect() {
    _state = _state.copyWith(isConnecting: true);
    notifyListeners();
  }

  void disConnect() {
    _state = _state.copyWith(isConnecting: false);
    notifyListeners();
  }
}
