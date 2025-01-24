// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultState {
  final List<ScanResult> scanResults;

  ScanResultState({required this.scanResults});

  factory ScanResultState.initial() {
    return ScanResultState(scanResults: []);
  }

  ScanResultState copyWith({
    List<ScanResult>? scanResults,
  }) {
    return ScanResultState(
      scanResults: scanResults ?? this.scanResults,
    );
  }

  @override
  String toString() => 'ScanResultState(scanResults: $scanResults)';
}
