import 'dart:convert';

import 'package:geo_j/constants/constants.dart';
import 'package:geo_j/models/device/device_logdata_info.dart';
import 'package:geo_j/models/login/signin_info.dart';
import 'package:geo_j/services/http_error_handler.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final http.Client httpClient;

  ApiServices({required this.httpClient});

  Future<List<A10>> getDeviceList() async {
    var client = http.Client();

    try {
      final http.Response response = await client.post(Uri.parse(kLoginUri),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: {"what_data": "DeviceList"});

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      // print(response.body.toString());
      final List<dynamic> responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        // throw WeatherException('Cannot get the location of $city');
      }

      final deviceList = responseBody.map((i) => A10.fromJson(i)).toList();

      print('Devicelist : $deviceList');

      return deviceList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dsitSendLogData(
      A10 a10, List<LogData> logDatas, String url) async {
    String body = '';
    for (int i = 0; i < logDatas.length; i++) {
      body += '0' +
          '|' +
          "SENSOR_${a10.deNumber}" +
          '|' +
          logDatas[i].temperature.toString() +
          '|' +
          logDatas[i].humidity.toString() +
          '|' +
          a10.battery.toString() +
          '|' +
          '0' +
          '|' +
          '0' +
          '|' +
          logDatas[i].timeStamp.toString() +
          '|' +
          logDatas[i].timeStamp.toString() +
          '|' +
          '0' +
          '|' +
          '0' +
          '|' +
          '1' +
          ';';
    }

    var client = http.Client();
    var uristring = "http://gep.thermocert.net:19987";
    var uri = Uri.parse(uristring);
    print(uristring.toString());
    var uriResponse = await client.post(uri, body: {"data": body});
    print("Response: ${uriResponse.body}");
  }

  // Future<void> sendLogData(A10 a10, List<LogData> logDatas, String url) async {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   final Map<String, dynamic> response = new Map<String, dynamic>();
  //   final Map<String, dynamic> common = new Map<String, dynamic>();
  //   final Map<String, dynamic> item = new Map<String, dynamic>();
  //   final List<dynamic> itemlist = [];

  //   common['shippingSeq'] = a10.shippingSeq;
  //   common['deNumber'] = a10.deNumber;
  //   common['boxName'] = a10.boxName;

  //   item["itemlist"] = itemlist;
  //   response["item"] = item;
  //   response["common"] = common;
  //   data["response"] = response;

  //   List<LogData> list = logDatas;
  //   // bool isOver = false;
  //   int transportState = 999;

  //   int itemIndex = 0;
  //   for (int i = 0; i < list.length; i++) {
  //     // 현재 날짜와 arravalTime의 월,일이 같은 날짜에 arravalTime 이후에 들어온 데이터 일 시, -1 전송
  //     if (list[i].timeStamp.toLocal().isAfter(a10.arrivalTime) &&
  //         (new DateTime.now().toLocal().toString().substring(5, 10) ==
  //             a10.arrivalTime.toLocal().toString().substring(5, 10))) {
  //       transportState = -1;
  //     } else {
  //       transportState = a10.transportState;
  //     }

  //     itemlist.add(new Map<String, dynamic>());
  //     itemlist[itemIndex]["temp"] = list[i].temperature;
  //     itemlist[itemIndex]["hum"] = list[i].humidity;
  //     itemlist[itemIndex]["battery"] = a10.battery;
  //     itemlist[itemIndex]["datetime"] =
  //         list[i].timeStamp.toLocal().toIso8601String();
  //     // 이탈 체크
  //     if (list[i].temperature < a10.tempHigh &&
  //         list[i].temperature > a10.tempLow) {
  //       itemlist[itemIndex]["tempCount"] = 0;
  //     } else {
  //       itemlist[itemIndex]["tempCount"] = 1;
  //       // isOver = true;
  //     }
  //     itemlist[itemIndex]["humCount"] = 0;
  //     itemlist[itemIndex]["transportState"] = transportState.toString();
  //     itemIndex++;
  //   }

  //   var client = http.Client();
  //   var uri = Uri.parse(url);
  //   try {
  //     final http.Response response = await client.post(uri,
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode(data));

  //     if (response.statusCode != 200) {
  //       throw Exception(httpErrorHandler(response));
  //     }

  //     final Map<String, dynamic> responseBody = json.decode(response.body);

  //     if (responseBody.isEmpty) {
  //       // throw WeatherException('Cannot get the location of $city');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<void> updateTransportState(
  //     A10 a10, int transportState, String url) async {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   final Map<String, dynamic> response = new Map<String, dynamic>();
  //   final Map<String, dynamic> common = new Map<String, dynamic>();
  //   final Map<String, dynamic> item = new Map<String, dynamic>();
  //   final List<dynamic> itemlist = [];

  //   common['shippingSeq'] = a10.shippingSeq;
  //   common['deNumber'] = a10.deNumber;
  //   common['boxName'] = a10.boxName;

  //   item["itemlist"] = itemlist;
  //   response["item"] = item;
  //   response["common"] = common;
  //   data["response"] = response;

  //   int itemIndex = 0;

  //   itemlist.add(new Map<String, dynamic>());
  //   itemlist[itemIndex]["temp"] = 9999;
  //   itemlist[itemIndex]["hum"] = 0;
  //   itemlist[itemIndex]["battery"] = a10.battery;
  //   itemlist[itemIndex]["datetime"] = DateTime.now().toLocal().toString();
  //   itemlist[itemIndex]["tempCount"] = 0;
  //   itemlist[itemIndex]["humCount"] = 0;
  //   itemlist[itemIndex]["transportState"] = transportState;
  //   itemIndex++;

  //   var client = http.Client();
  //   var uri = Uri.parse(url);
  //   try {
  //     final http.Response response = await client.post(uri,
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode(data));

  //     if (response.statusCode != 200) {
  //       throw Exception(httpErrorHandler(response));
  //     }

  //     // print(response.body.toString());
  //     final Map<String, dynamic> responseBody = json.decode(response.body);

  //     if (responseBody.isEmpty) {
  //       // throw WeatherException('Cannot get the location of $city');
  //     }
  //   } catch (e) {
  //     print('updateTransportState ERR');
  //     rethrow;
  //   }
  // }

  // Future<void> sendGpsData(
  //     LocationData locationData, SigninInfo signinInfo) async {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   final Map<String, dynamic> response = new Map<String, dynamic>();
  //   final Map<String, dynamic> common = new Map<String, dynamic>();
  //   final Map<String, dynamic> item = new Map<String, dynamic>();
  //   final List<dynamic> itemlist = [];

  //   common['deNumber'] = signinInfo.centerInfo.managerPn;

  //   itemlist.add(new Map<String, dynamic>());
  //   itemlist[0]["lat"] = locationData.latitude.toString();
  //   itemlist[0]["lng"] = locationData.longitude.toString();
  //   item["itemlist"] = itemlist;
  //   response["item"] = item;
  //   response["common"] = common;
  //   data["response"] = response;

  //   var client = http.Client();
  //   var uri = Uri.parse(signinInfo.centerInfo.sendLogDataUri);
  //   try {
  //     final http.Response response = await client.post(uri,
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode(data));

  //     if (response.statusCode != 200) {
  //       throw Exception(httpErrorHandler(response));
  //     }

  //     // print(response.body.toString());
  //     final Map<String, dynamic> responseBody = json.decode(response.body);

  //     if (responseBody.isEmpty) {
  //       // throw WeatherException('Cannot get the location of $city');
  //     }

  //     // print("GPS DATA" + data.toString());
  //   } catch (e) {
  //     print('updateTransportState ERR');
  //     rethrow;
  //   }
  // }
}
