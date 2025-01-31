import 'package:collection/collection.dart';
import 'package:geo_j/models/device/device_logdata_info.dart';
import 'package:geo_j/models/error/custom_error.dart';
import 'package:geo_j/models/login/signin_info.dart';
import 'package:geo_j/services/api_services.dart';

class LogdataRepositories {
  final ApiServices apiServices;

  LogdataRepositories({required this.apiServices});

  Future<void> sendLogData({
    required A10 a10,
    required List<LogData> logDatas,
  }) async {
    try {
      await apiServices.dsitSendLogData(a10, logDatas);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
