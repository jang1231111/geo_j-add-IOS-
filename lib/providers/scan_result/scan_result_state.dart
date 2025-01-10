// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultState {
  final List<ScanResult> scanResuls;

  ScanResultState({required this.scanResuls});

  factory ScanResultState.initail() {
    return ScanResultState(scanResuls: []);
  }

  ScanResultState copyWith({
    List<ScanResult>? scanResuls,
  }) {
    return ScanResultState(
      scanResuls: scanResuls ?? this.scanResuls,
    );
  }

  @override
  String toString() => 'ScanResultState(scanResuls: $scanResuls)';
}
