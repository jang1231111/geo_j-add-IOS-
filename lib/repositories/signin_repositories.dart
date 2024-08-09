import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/services/api_services.dart';

class SigninRepositories {
  final ApiServices apiServices;

  SigninRepositories({required this.apiServices});

  Future<SigninInfo> signin() async {
    try {
      final List<A10> deviceList = await apiServices.getDeviceList();

      // for (int i = 0; i < deviceList.length; i++) {
      //   print('**********************');
      //   print('Device : ${deviceList[i]}');
      //   print('**********************');
      // }

      SigninInfo signinInfo = SigninInfo(devices: deviceList);

      return signinInfo;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
