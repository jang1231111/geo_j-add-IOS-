import 'package:flutter/material.dart';
import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/providers/signin/signin_state.dart';
import 'package:geo_j/repositories/signin_repositories.dart';
import 'package:geo_j/repositories/transport_state_repositories.dart';

class SigninProvider with ChangeNotifier {
  SigninState _state = SigninState.initial();
  SigninState get state => _state;
  SigninProvider(
      {required this.signinRepositories, required this.transportRepositories});

  final SigninRepositories signinRepositories;
  final ShipstateRepositories transportRepositories;

  Future<void> signin({
    required String phoneNumber,
  }) async {
    _state = _state.copyWith(signinStatus: SigninStatus.submitting);
    notifyListeners();

    try {
      final signinInfo =
          await signinRepositories.signin(phoneNumber: phoneNumber);
      _state = _state.copyWith(
          signinStatus: SigninStatus.success, signinInfo: signinInfo);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(signinStatus: SigninStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateTransportState({
    required A10 a10,
    required int transportState,
  }) async {
    try {
      final deviceList = await transportRepositories.updateTransportState(
          a10: a10,
          transportState: transportState,
          signinInfo: _state.signinInfo);

      SigninInfo signinInfo = _state.signinInfo.copyWith(devices: deviceList);

      _state = _state.copyWith(signinInfo: signinInfo);
      notifyListeners();

      _state = _state.copyWith(
          signinStatus: SigninStatus.success, signinInfo: signinInfo);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(signinStatus: SigninStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }

  // Future<void> getDeviceList({
  //   required String phoneNumber,
  // }) async {
  //   try {
  //     final centerInfo = _state.signinInfo.centerInfo;
  //     final deviceList =
  //         await signinRepositories.getDeviceList(centerinfo: centerInfo);

  //     SigninInfo signinInfo = _state.signinInfo.copyWith(devices: deviceList);

  //     _state = _state.copyWith(signinInfo: signinInfo);
  //     notifyListeners();
  //   } on CustomError catch (e) {
  //     _state = _state.copyWith(signinStatus: SigninStatus.error, error: e);
  //     notifyListeners();
  //     rethrow;
  //   }
  // }

  bool updateAdvertise(
      {required String serial,
      required double temeperature,
      required int battery}) {
    List<A10> devices = _state.signinInfo.devices;

    for (int i = 0; i < devices.length; i++) {
      if (devices[i].deNumber.replaceAll('SENSOR_', '').toLowerCase() ==
          serial.toLowerCase()) {
        devices[i] =
            devices[i].copyWith(temperature: temeperature, battery: battery);

        _state = _state.copyWith(
            signinInfo: _state.signinInfo.copyWith(devices: devices));

        notifyListeners();
        // if(업데이트를 해야할 시간) {
        return true;
        // }
        // 안해도 되는 시간
        //  else {
        //   return false;
        // }
      }
    }
    return false;
  }

  void updateState({
    required A10 a10,
    required String state,
  }) async {
    List<A10> devices = _state.signinInfo.devices;

    for (int i = 0; i < devices.length; i++) {
      if (devices[i].deNumber.toLowerCase() == a10.deNumber.toLowerCase()) {
        devices[i] = devices[i].copyWith(bleState: state);
        break;
      }
    }

    _state = _state.copyWith(
        signinInfo: _state.signinInfo.copyWith(devices: devices));

    notifyListeners();
  }
}
