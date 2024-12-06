// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geo_j/models/bluetooth.dart';
import 'package:geo_j/models/signin_info.dart';

class ScannedDeviecsState {
  final BleStatus bleStatus;
  final List<A10> scannedDevices;
  final Timer scanTimer;

  ScannedDeviecsState({
    required this.bleStatus,
    required this.scannedDevices,
    required this.scanTimer,
  });

  factory ScannedDeviecsState.initial() {
    return ScannedDeviecsState(
        bleStatus: BleStatus.initial,
        scannedDevices: [],
        scanTimer: Timer.periodic(
          const Duration(minutes: 1),
          (_) async {
            await FlutterBluePlus.stopScan();
            await FlutterBluePlus.startScan(
                timeout: const Duration(minutes: 10),
                withNames: [
                  'T301',
                  'T305',
                  'T306',
                ]);

            /// 상태관리 사용으로 인해, UI 리빌드가 필요할때를 제외하고 발생하지 않음
            /// DateTime (파란불,빨간불) 이 시간이 지나도 상태관리를 이용한 변환이 없을시 리빌드가 이루어지지 않으므로 스캔 재시작 시마다 화면을 새로 그려준다
            // setState(() {});
          },
        ));
  }

  ScannedDeviecsState copyWith({
    BleStatus? bleStatus,
    List<A10>? scannedDevices,
    Timer? scanTimer,
  }) {
    return ScannedDeviecsState(
      bleStatus: bleStatus ?? this.bleStatus,
      scannedDevices: scannedDevices ?? this.scannedDevices,
      scanTimer: scanTimer ?? this.scanTimer,
    );
  }

  @override
  String toString() =>
      'BluetoothState(bleStatus: $bleStatus, scannedDevices: $scannedDevices, scanTimer: $scanTimer)';
}
