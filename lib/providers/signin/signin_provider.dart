import 'package:flutter/material.dart';
import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/providers/signin/signin_state.dart';
import 'package:geo_j/repositories/signin_repositories.dart';

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

  void updateAdvertise(
      {required String deNumber,
      required double temeperature,
      required int battery}) {
    List<Device> devices = _state.signinInfo.devices;

    for (int i = 0; i < devices.length; i++) {
      if (devices[i].deNumber.replaceAll('SENSOR_', '').toLowerCase() ==
          deNumber.toLowerCase()) {
        devices[i] =
            devices[i].copyWith(temperature: temeperature, battery: battery);
        print('device[i] ${devices[i]}');
      }
    }

    _state = _state.copyWith(
        signinInfo: _state.signinInfo.copyWith(devices: devices));

    notifyListeners();
  }
}
