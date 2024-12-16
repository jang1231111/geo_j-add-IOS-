import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/services/api_services.dart';

class SigninRepositories {
  final ApiServices apiServices;

  SigninRepositories({required this.apiServices});

  Future<SigninInfo> signin({required String phoneNumber}) async {
    try {
      final Centerinfo centerinfo =
          await apiServices.getCenterInfo(phoneNumber);
      print('CenterInfo : $centerinfo');

      final List<A10> deviceList = await apiServices.getDeviceList(centerinfo);

      // for (int i = 0; i < deviceList.length; i++) {
      //   print('**********************');
      //   print('Device : ${deviceList[i]}');
      //   print('**********************');
      // }

      SigninInfo signinInfo =
          SigninInfo(centerInfo: centerinfo, devices: deviceList);

      return signinInfo;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
