import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/log_data.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/services/api_services.dart';

class LogdataRepositories {
  final ApiServices apiServices;

  LogdataRepositories({required this.apiServices});

  Future<A10?> sendLogData({
    required String serial,
    required SigninInfo signinInfo,
    required List<LogData> logDatas,
  }) async {
    /// 전송 기기
    List<A10> devices = signinInfo.devices;
    A10? a10;
    for (int i = 0; i < devices.length; i++) {
      if (devices[i].deNumber.replaceAll('SENSOR_', '').toLowerCase() ==
          serial.toLowerCase()) {
        a10 = devices[i];
        break;
      }
    }

    /// 목록에 기기 없는 경우
    if (a10 == null) {
      return null;
    }

    /// 데이터 전송
    try {
      // await apiServices.sendLogData(          a10, logDatas, signinInfo.centerInfo.sendLogDataUri);
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
