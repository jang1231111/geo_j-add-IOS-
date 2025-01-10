import 'package:geo_j/providers/scan_result/scan_result_state.dart';

class ScanResultProvider {
  ScanResultState _state = ScanResultState.initial();
  ScanResultState get state => _state;
}
