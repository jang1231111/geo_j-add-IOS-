import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/services/api_services.dart';

class ShipstateRepositories {
  final ApiServices apiServices;

  ShipstateRepositories({required this.apiServices});

  Future<A10?> updateTransportState(
      {required A10 a10,
      required int transportState,
      required SigninInfo signinInfo}) async {
    try {
      await apiServices.updateTransportState(
          a10, transportState, signinInfo.centerInfo.sendLogDataUri);

      final List<A10> devices =
          await apiServices.getDeviceList(signinInfo.centerInfo);

      A10? updated_A10;

      for (int i = 0; i < devices.length; i++) {
        if (devices[i].boxName == a10.boxName) {
          updated_A10 = devices[i];
          break;
        }
      }
      return updated_A10;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
