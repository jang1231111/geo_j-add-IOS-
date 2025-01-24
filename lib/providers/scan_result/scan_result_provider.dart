import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geo_j/providers/scan_result/scan_result_state.dart';

class ScanResultProvider extends ChangeNotifier {
  ScanResultState _state = ScanResultState.initial();
  ScanResultState get state => _state;

  ScanResultProvider();

  Future<void> updateScanResults(
      {required List<ScanResult> newScanResults}) async {
    _state = _state.copyWith(scanResults: newScanResults);
    notifyListeners();
  }
}
