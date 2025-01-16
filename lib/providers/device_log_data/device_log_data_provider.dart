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

  // Future<void> sendLogData({
  //   required String serial,
  //   required List<LogData> logDatas,
  //   required List<A10> devices,
  // }) async {
  //   try {
  //     final updated_A10 = await logDataRepositories.sendLogData(
  //         serial: serial, devices: devices, logDatas: logDatas);

  //     if (updated_A10 == null) {
  //       return;
  //     }

  //     for (int i = 0; i < devices.length; i++) {
  //       if (devices[i].deNumber == updated_A10.deNumber) {
  //         devices[i] = devices[i].copyWith(datetime: updated_A10.datetime);
  //       }
  //     }

  //     DeviceLogDataInfo deviceLogDataInfo =
  //         _state.deviceLogDataInfo.copyWith(logdatas: logDatas);

  //     _state = _state.copyWith(
  //         centerDataInfo: deviceLogDataInfo,
  //         status: DeviceLogDataStatus.success);
  //     notifyListeners();
  //   } on CustomError catch (e) {
  //     _state = _state.copyWith(status: DeviceLogDataStatus.error, error: e);
  //     notifyListeners();
  //     rethrow;
  //   }
  // }
}
