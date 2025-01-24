import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geo_j/models/error/custom_error.dart';
import 'package:geo_j/models/login/signin_info.dart';
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

    /// Adevertise Update
    final newDeviceList = devices.map((device) {
      if (device.deNumber.replaceAll('SENSOR_', '').toLowerCase() ==
          serial.toLowerCase()) {
        final updatedDevice = device.copyWith(
          temperature: temperature,
          battery: battery,
          scanned: true,
        );

        // 데이터 전송 시간 체크
        if (device.datetime.isBefore(
            DateTime.now().toLocal().subtract(Duration(minutes: 10)))) {
          isUpdate = true;
        }

        return updatedDevice;
      }

      return device;
    }).toList();

    _state = _state.copyWith(
        signinInfo: _state.signinInfo.copyWith(devices: newDeviceList));

    notifyListeners();

    return isUpdate;
  }

  void updateStartTime(A10 device) {
    final deviceList = _state.signinInfo.devices;
    final updatedDevice = device.copyWith(startTime: DateTime.now());

    final newDeviceList = deviceList.map((d) {
      return d.deNumber == device.deNumber ? updatedDevice : d;
    }).toList();

    _state = _state.copyWith(
        signinInfo: _state.signinInfo.copyWith(devices: newDeviceList));

    notifyListeners();
  }

  void updateSendCount(A10 device) {
    final deviceList = _state.signinInfo.devices;
    final updatedDevice = device.copyWith(sendCount: device.sendCount! + 1);

    final newDeviceList = deviceList.map((d) {
      return d.deNumber == device.deNumber ? updatedDevice : d;
    }).toList();

    _state = _state.copyWith(
        signinInfo: _state.signinInfo.copyWith(devices: newDeviceList));

    notifyListeners();
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
