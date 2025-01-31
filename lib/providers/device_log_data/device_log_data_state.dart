// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:geo_j/models/device/device_logdata_info.dart';
import 'package:geo_j/models/error/custom_error.dart';
import 'package:geo_j/models/login/signin_info.dart';

enum DeviceLogDataStatus {
  initial,
  submitting,
  success,
  error,
}

class DeviceLogDataState {
  final DeviceLogDataStatus status;
  final A10 a10;
  final List<LogData> logDatas;
  final CustomError error;

  DeviceLogDataState(
      {required this.status,
      required this.a10,
      required this.logDatas,
      required this.error});

  factory DeviceLogDataState.initial() {
    return DeviceLogDataState(
        status: DeviceLogDataStatus.initial,
        a10: A10(
            boxName: 'initial',
            deNumber: 'initial',
            deLocation: 'initial',
            datetime: DateTime.now()),
        logDatas: [],
        error: CustomError());
  }

  DeviceLogDataState copyWith({
    DeviceLogDataStatus? status,
    A10? a10,
    List<LogData>? logDatas,
    CustomError? error,
  }) {
    return DeviceLogDataState(
      status: status ?? this.status,
      a10: a10 ?? this.a10,
      logDatas: logDatas ?? this.logDatas,
      error: error ?? this.error,
    );
  }
}
