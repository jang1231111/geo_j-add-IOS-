import 'package:flutter/material.dart';
import 'package:geo_j/models/device/device_logdata_info.dart';
import 'package:geo_j/models/error/custom_error.dart';
import 'package:geo_j/models/login/signin_info.dart';
import 'package:geo_j/providers/device_log_data/device_log_data_state.dart';
import 'package:geo_j/repositories/log_data_repositories.dart';

class DeviceLogDataProvider with ChangeNotifier {
  DeviceLogDataState _state = DeviceLogDataState.initial();
  DeviceLogDataState get state => _state;

  final LogdataRepositories logDataRepositories;

  DeviceLogDataProvider({
    required this.logDataRepositories,
  });

  Future<void> sendLogData({
    required String serial,
    required List<LogData> logDatas,
    required List<A10> devices,
  }) async {
    try {
      await logDataRepositories.sendLogData(
          serial: serial, devices: devices, logDatas: logDatas);

      _state = _state.copyWith(
          logDatas: logDatas, status: DeviceLogDataStatus.success);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(status: DeviceLogDataStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
