import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/log_data.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/services/api_services.dart';

class LogdataRepositories {
  final ApiServices apiServices;

  LogdataRepositories({required this.apiServices});

  Future<void> sendLogData({
    required List<int> notifyResult,
    required SigninInfo signinInfo,
    required List<LogData> logDatas,
  }) async {
    /// Serial
    List<int> serials = notifyResult.sublist(4, 7).reversed.toList();
    String serial = '';
    for (int i = 0; i < serials.length; i++) {
      serial += serials[i].toRadixString(16);
    }

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

    /// 데이터 전송
    try {
      await apiServices.sendLogData(
          a10, logDatas, signinInfo.centerInfo.sendLogDataUri);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
