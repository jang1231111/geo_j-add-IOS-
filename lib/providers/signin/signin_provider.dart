import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/log_data.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/providers/signin/signin_state.dart';
import 'package:geo_j/repositories/log_data_repositories.dart';
import 'package:geo_j/repositories/signin_repositories.dart';
import 'package:geo_j/repositories/transport_state_repositories.dart';

class SigninProvider with ChangeNotifier {
  SigninState _state = SigninState.initial();
  SigninState get state => _state;

  SigninProvider(
      {required this.signinRepositories,
      required this.transportRepositories,
      required this.logDataRepositories});

  final SigninRepositories signinRepositories;
  final ShipstateRepositories transportRepositories;
  final LogdataRepositories logDataRepositories;

  Future<void> signin() async {
    _state = _state.copyWith(signinStatus: SigninStatus.submitting);
    notifyListeners();

    try {
      final signinInfo = await signinRepositories.signin();
      _state = _state.copyWith(
          signinStatus: SigninStatus.success, signinInfo: signinInfo);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(signinStatus: SigninStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }

  // Future<void> updateTransportState({
  //   required A10 a10,
  //   required int transportState,
  // }) async {
  //   try {
  //     final updated_A10 = await transportRepositories.updateTransportState(
  //         a10: a10,
  //         transportState: transportState,
  //         signinInfo: _state.signinInfo);

  //     if (updated_A10 == null) {
  //       return;
  //     }

  //     final deviceList = _state.signinInfo.devices;

  //     for (int i = 0; i < deviceList.length; i++) {
  //       if (deviceList[i].boxName == updated_A10.boxName) {
  //         deviceList[i] = deviceList[i]
  //             .copyWith(transportState: updated_A10.transportState);
  //         break;
  //       }
  //     }

  //     SigninInfo signinInfo = _state.signinInfo.copyWith(devices: deviceList);

  //     _state = _state.copyWith(signinInfo: signinInfo);
  //     notifyListeners();
  //   } on CustomError catch (e) {
  //     _state = _state.copyWith(signinStatus: SigninStatus.error, error: e);
  //     notifyListeners();
  //     rethrow;
  //   }
  // }

  Future<void> sendLogData({
    required String serial,
    required List<LogData> logDatas,
  }) async {
    try {
      final updated_A10 = await logDataRepositories.sendLogData(
          serial: serial, signinInfo: _state.signinInfo, logDatas: logDatas);

      if (updated_A10 == null) {
        return;
      }

      final deviceList = _state.signinInfo.devices;

      for (int i = 0; i < deviceList.length; i++) {
        if (deviceList[i].deNumber == updated_A10.deNumber) {
          deviceList[i] =
              deviceList[i].copyWith(datetime: updated_A10.datetime);
        }
      }

      SigninInfo signinInfo = _state.signinInfo.copyWith(devices: deviceList);

      _state = _state.copyWith(signinInfo: signinInfo);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(signinStatus: SigninStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }

  bool updateAdvertise({
    required String serial,
    required Uint8List advertiseData,
  }) {
    List<A10> devices = _state.signinInfo.devices;
    bool isUpdate = false;

    /// Temperature
    int tmp = ByteData.sublistView(advertiseData.sublist(10, 12))
        .getInt16(0, Endian.big);

    double temperature = tmp / 100;

    /// Battery
    int battery = advertiseData[14];

    for (int i = 0; i < devices.length; i++) {
      if (devices[i].deNumber.replaceAll('SENSOR_', '').toLowerCase() ==
          serial.toLowerCase()) {
        final A10 updatedDevice = devices[i].copyWith(
            temperature: temperature, battery: battery, scanned: true);
        devices[i] = updatedDevice;
        _state = _state.copyWith(
            signinInfo: _state.signinInfo.copyWith(devices: devices));

        notifyListeners();

        // 데이터 전송 시간 체크
        if (devices[i].datetime.isBefore(
            DateTime.now().toLocal().subtract(Duration(minutes: 10)))) {
          isUpdate = true;
        }
      }
    }
    return isUpdate;
  }

  // void updateBleState({
  //   required String serial,
  //   required String bleState,
  // }) async {
  //   List<A10> devices = _state.signinInfo.devices;

  //   for (int i = 0; i < devices.length; i++) {
  //     if (devices[i].deNumber.replaceAll('SENSOR_', '').toLowerCase() ==
  //         serial.toLowerCase()) {
  //       devices[i] = devices[i].copyWith(bleState: bleState);
  //       break;
  //     }
  //   }

  //   _state = _state.copyWith(
  //       signinInfo: _state.signinInfo.copyWith(devices: devices));

  //   notifyListeners();
  // }
}
