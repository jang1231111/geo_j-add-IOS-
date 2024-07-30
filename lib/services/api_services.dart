import 'dart:convert';

import 'package:geo_j/constants/constants.dart';
import 'package:geo_j/models/log_data.dart';
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

  Future<List<A10>> getDeviceList(Centerinfo centerInfo) async {
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

      final deviceList = responseBody.map((i) => A10.fromJson(i)).toList();

      print('Devicelist : $deviceList');

      return deviceList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendLogData(A10? a10, List<LogData> logDatas, String url) async {
    if (a10 == null) {
      return;
    }

    // 전송 데이터 JSON
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final Map<String, dynamic> response = new Map<String, dynamic>();
    final Map<String, dynamic> common = new Map<String, dynamic>();
    final Map<String, dynamic> item = new Map<String, dynamic>();
    final List<dynamic> itemlist = [];

    // common 안에 seq
    common['shippingSeq'] = a10.shippingSeq;
    common['deNumber'] = a10.deNumber;
    common['boxName'] = a10.boxName;

    item["itemlist"] = itemlist;
    response["item"] = item;
    response["common"] = common;
    data["response"] = response;

    List<LogData> list = logDatas;
    // bool isOver = false;
    int transportState = 999;

    int itemIndex = 0;
    for (int i = 0; i < list.length; i++) {
      // 현재 날짜와 arravalTime의 월,일이 같은 날짜에 arravalTime 이후에 들어온 데이터 일 시, -1 전송
      if (list[i].timeStamp.toLocal().isAfter(a10.arrivalTime) &&
          (new DateTime.now().toLocal().toString().substring(5, 10) ==
              a10.arrivalTime.toLocal().toString().substring(5, 10))) {
        transportState = -1;
      } else {
        transportState = a10.transportState;
      }

      itemlist.add(new Map<String, dynamic>());
      itemlist[itemIndex]["temp"] = list[i].temperature;
      itemlist[itemIndex]["hum"] = list[i].humidity;
      itemlist[itemIndex]["battery"] = a10.battery;
      itemlist[itemIndex]["datetime"] =
          list[i].timeStamp.toLocal().toIso8601String();
      // 이탈 체크
      if (list[i].temperature < a10.tempHigh &&
          list[i].temperature > a10.tempLow) {
        itemlist[itemIndex]["tempCount"] = 0;
      } else {
        itemlist[itemIndex]["tempCount"] = 1;
        // isOver = true;
      }
      itemlist[itemIndex]["humCount"] = 0;
      itemlist[itemIndex]["transportState"] = transportState.toString();
      itemIndex++;
    }

    // if (isOver) {
    //   await _showNotification(device.boxName, device.destName);
    // }

    var client = http.Client();
    var uri = Uri.parse(url);
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
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTransportState(
      A10 a10, int transportState, String url) async {
    print('updateTransportState');
    // 전송 데이터 JSON
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final Map<String, dynamic> response = new Map<String, dynamic>();
    final Map<String, dynamic> common = new Map<String, dynamic>();
    final Map<String, dynamic> item = new Map<String, dynamic>();
    final List<dynamic> itemlist = [];

    // common 안에 seq
    common['shippingSeq'] = a10.shippingSeq;
    common['deNumber'] = a10.deNumber;
    common['boxName'] = a10.boxName;

    item["itemlist"] = itemlist;
    response["item"] = item;
    response["common"] = common;
    data["response"] = response;

    int itemIndex = 0;

    itemlist.add(new Map<String, dynamic>());
    itemlist[itemIndex]["temp"] = 9999;
    itemlist[itemIndex]["hum"] = 0;
    itemlist[itemIndex]["battery"] = a10.battery;
    itemlist[itemIndex]["datetime"] = DateTime.now().toLocal().toString();
    itemlist[itemIndex]["tempCount"] = 0;
    itemlist[itemIndex]["humCount"] = 0;
    itemlist[itemIndex]["transportState"] = transportState;
    itemIndex++;

    var client = http.Client();
    var uri = Uri.parse(url);
    try {
      print('updateTransportState test1');
      final http.Response response = await client.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data));

      print('updateTransportState test2');

      if (response.statusCode != 200) {
        print('updateTransportState test3');
        throw Exception(httpErrorHandler(response));
      }
      print('updateTransportState test4');

      print(response.body.toString());
      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        // throw WeatherException('Cannot get the location of $city');
      }
    } catch (e) {
      print('updateTransportState ERR');
      rethrow;
    }
  }
}
