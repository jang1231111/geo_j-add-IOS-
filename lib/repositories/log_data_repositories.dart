import 'package:collection/collection.dart';
import 'package:geo_j/models/device/device_logdata_info.dart';
import 'package:geo_j/models/error/custom_error.dart';
import 'package:geo_j/models/login/signin_info.dart';
import 'package:geo_j/services/api_services.dart';

class LogdataRepositories {
  final ApiServices apiServices;

  LogdataRepositories({required this.apiServices});

  Future<A10?> sendLogData({
    required String serial,
    required List<A10> devices ,
    required List<LogData> logDatas,
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

    /// 데이터 전송
    try {
      await apiServices.dsitSendLogData(a10, logDatas);
      final List<A10> newDevices = await apiServices.getDeviceList();

      for (int i = 0; i < newDevices.length; i++) {
        if (newDevices[i].deNumber.replaceAll('SENSOR_', '').toLowerCase() ==
            serial.toLowerCase()) {
          a10 = newDevices[i];
          break;
        }
      }

      return a10;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
