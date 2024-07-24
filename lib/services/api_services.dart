import 'dart:convert';

import 'package:geo_j/constants/constants.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/services/http_error_handler.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final http.Client httpClient;

  ApiServices({required this.httpClient});

  Future<Centerinfo> getCenterInfo(String phoneNumber) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final Map<String, dynamic> response = new Map<String, dynamic>();
    final Map<String, dynamic> common = new Map<String, dynamic>();

    common['managerPn'] = phoneNumber;
    response["common"] = common;
    data["response"] = response;

    var client = http.Client();
    var uri = Uri.parse(kLoginUri);

    try {
      final http.Response response = await client.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final responseBody = json.decode(response.body);

      if (responseBody.toString() ==
          '{msg: No Data In MANAGER_INFO, notice: []}') {
        throw Exception('전화번호를 확인해 주세요');
      }

      print(responseBody.toString());
      final centerInfo = Centerinfo.fromJson(responseBody);

      return centerInfo;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Device>> getDeviceList(Centerinfo centerInfo) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final Map<String, dynamic> response = new Map<String, dynamic>();
    final Map<String, dynamic> common = new Map<String, dynamic>();

    common['managerPn'] = centerInfo.managerPn;
    response["common"] = common;
    data["response"] = response;

    var client = http.Client();
    var uri = Uri.parse(centerInfo.getDeviceListUri);

    try {
      final http.Response response = await client.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      print(response.body.toString());
      final List<dynamic> responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        // throw WeatherException('Cannot get the location of $city');
      }

      final deviceList = responseBody.map((i) => Device.fromJson(i)).toList();

      print('Devicelist : $deviceList');

      return deviceList;
    } catch (e) {
      rethrow;
    }
  }
}
