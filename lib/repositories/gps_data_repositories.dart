import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/services/api_services.dart';
import 'package:location/location.dart';

class GpsDataRepositories {
  final ApiServices apiServices;

  GpsDataRepositories({required this.apiServices});

  void sendGpsData(LocationData? locationData, SigninInfo signinInfo) async {
    if (locationData == null) {
      return;
    }

    try {
      await apiServices.sendGpsData(locationData, signinInfo);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
