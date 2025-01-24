import 'package:flutter/material.dart';

class ConnectingProvider extends ChangeNotifier {
  bool _isConnecting = false;

  bool get isConnecting => _isConnecting;

  void connect() {
    _isConnecting = true;
    notifyListeners();
  }

  void disConnect() {
    _isConnecting = false;
    notifyListeners();
  }
}
