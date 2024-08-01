import 'package:geo_j/models/log_data.dart';

enum Filter {
  all,
  active,
  completed,
}

class SigninInfo {
  final Centerinfo centerInfo;
  final List<A10> devices;

  factory SigninInfo.initial() {
    return SigninInfo(
        centerInfo: Centerinfo(
            centerNm: '',
            centerSn: 0,
            managerPn: '',
            getDeviceListUri: '',
            sendLogDataUri: ''),
        devices: []);
  }

  SigninInfo({required this.centerInfo, required this.devices});

  @override
  String toString() => 'SigninInfo(centerInfo: $centerInfo, devices: $devices)';

  SigninInfo copyWith({
    Centerinfo? centerInfo,
    List<A10>? devices,
  }) {
    return SigninInfo(
      centerInfo: centerInfo ?? this.centerInfo,
      devices: devices ?? this.devices,
    );
  }
}

class Centerinfo {
  final int centerSn;
  final String centerNm;
  final String managerPn;
  final String getDeviceListUri;
  final String sendLogDataUri;

  Centerinfo(
      {required this.centerSn,
      required this.centerNm,
      required this.managerPn,
      required this.getDeviceListUri,
      required this.sendLogDataUri});

  factory Centerinfo.fromJson(Map<String, dynamic> json) {
    return Centerinfo(
      centerSn: json['centerSn'],
      centerNm: json['centerNm'],
      managerPn: json['managerPn'],
      getDeviceListUri:
          "http://${json['ip']}:${json['loginPort']}/box/${json['appType']}",
      sendLogDataUri: "http://${json['ip']}:${json['dataPort']}",
    );
  }

  Centerinfo copyWith({
    int? centerSn,
    String? centerNm,
    String? managerPn,
    String? getDeviceListUri,
    String? sendLogDataUri,
  }) {
    return Centerinfo(
      centerSn: centerSn ?? this.centerSn,
      centerNm: centerNm ?? this.centerNm,
      managerPn: managerPn ?? this.managerPn,
      getDeviceListUri: getDeviceListUri ?? this.getDeviceListUri,
      sendLogDataUri: sendLogDataUri ?? this.sendLogDataUri,
    );
  }

  @override
  String toString() {
    return 'Centerinfo(centerSn: $centerSn, centerNm: $centerNm, managerPn: $managerPn, getDeviceListUri: $getDeviceListUri, sendLogDataUri: $sendLogDataUri)';
  }
}

class A10 {
  final int shippingSeq;
  final String boxName;
  final String deNumber;
  final String destination;
  final int transportState;
  final String dbNm;
  final int tempLow;
  final int tempHigh;
  final DateTime arrivalTime;
  final DateTime datetime;
  final double temperature;
  final int battery;
  final String bleState;
  final List<LogData> logDatas;

  A10({
    required this.shippingSeq,
    required this.boxName,
    required this.deNumber,
    required this.destination,
    required this.transportState,
    required this.dbNm,
    required this.tempLow,
    required this.tempHigh,
    required this.arrivalTime,
    required this.datetime,
    this.temperature = -999,
    this.battery = -999,
    this.bleState = '온도센서 스캔 중',
    this.logDatas = const [],
  });

  factory A10.fromJson(Map<String, dynamic> json) {
    return A10(
      shippingSeq: json['shippingSeq'],
      boxName: json['boxName'],
      deNumber: json['deNumber'],
      destination: json['destination'],
      transportState: json['transportState'],
      dbNm: json['dbNm'],
      tempLow: json['tempLow'],
      tempHigh: json['tempHigh'],
      arrivalTime: DateTime.parse(json['arrivalTime']),
      datetime: DateTime.parse(json['datetime']),
    );
  }

  A10 copyWith(
      {int? shippingSeq,
      String? boxName,
      String? deNumber,
      String? destination,
      int? transportState,
      String? dbNm,
      int? tempLow,
      int? tempHigh,
      DateTime? arrivalTime,
      DateTime? datetime,
      double? temperature,
      int? battery,
      String? bleState,
      List<LogData>? logDatas}) {
    return A10(
        shippingSeq: shippingSeq ?? this.shippingSeq,
        boxName: boxName ?? this.boxName,
        deNumber: deNumber ?? this.deNumber,
        destination: destination ?? this.destination,
        transportState: transportState ?? this.transportState,
        dbNm: dbNm ?? this.dbNm,
        tempLow: tempLow ?? this.tempLow,
        tempHigh: tempHigh ?? this.tempHigh,
        arrivalTime: arrivalTime ?? this.arrivalTime,
        datetime: datetime ?? this.datetime,
        temperature: temperature ?? this.temperature,
        battery: battery ?? this.battery,
        bleState: bleState ?? this.bleState,
        logDatas: logDatas ?? this.logDatas);
  }

  @override
  String toString() {
    return 'Device(shippingSeq: $shippingSeq, boxName: $boxName, deNumber: $deNumber, destination: $destination, transportState: $transportState, dbNm: $dbNm, tempLow: $tempLow, tempHigh: $tempHigh, arrivalTime: $arrivalTime, datetime: $datetime, temperature: $temperature, battery: $battery, bleState: $bleState, logDatas: $logDatas)';
  }
}
