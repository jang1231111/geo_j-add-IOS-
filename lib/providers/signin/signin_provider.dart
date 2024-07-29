import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/providers/signin/signin_state.dart';
import 'package:geo_j/repositories/signin_repositories.dart';
import 'package:geo_j/utils/bluetooth.dart';

class SigninProvider with ChangeNotifier {
  SigninState _state = SigninState.initial();
  SigninState get state => _state;
  SigninProvider({required this.signinRepositories});

  final SigninRepositories signinRepositories;

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
