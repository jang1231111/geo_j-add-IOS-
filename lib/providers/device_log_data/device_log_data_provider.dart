import 'package:collection/collection.dart';
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
    /// 전송 기기
    A10? a10 = devices.firstWhereOrNull(
      (device) =>
          device.deNumber.replaceAll('SENSOR_', '').toLowerCase() ==
          serial.toLowerCase(),
    );

    /// 목록에 기기 없는 경우
    if (a10 == null) {
      return null;
    }

    try {
      await logDataRepositories.sendLogData(a10: a10, logDatas: logDatas);

      _state = _state.copyWith(
          a10: a10, logDatas: logDatas, status: DeviceLogDataStatus.success);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(status: DeviceLogDataStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
