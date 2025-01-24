// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:geo_j/models/device/device_logdata_info.dart';
import 'package:geo_j/models/error/custom_error.dart';

enum DeviceLogDataStatus {
  initial,
  submitting,
  success,
  error,
}

class DeviceLogDataState {
  final DeviceLogDataStatus status;
  final String deNumber;
  final List<LogData> logDatas;
  final CustomError error;

  DeviceLogDataState(
      {required this.logDatas,
      required this.status,
      required this.deNumber,
      required this.error});

  factory DeviceLogDataState.initial() {
    return DeviceLogDataState(
        status: DeviceLogDataStatus.initial,
        deNumber: '',
        logDatas: [],
        error: CustomError());
  }

  DeviceLogDataState copyWith({
    DeviceLogDataStatus? status,
    String? deNumber,
    List<LogData>? logDatas,
    CustomError? error,
  }) {
    return DeviceLogDataState(
      status: status ?? this.status,
      deNumber: deNumber ?? this.deNumber,
      logDatas: logDatas ?? this.logDatas,
      error: error ?? this.error,
    );
  }
}
