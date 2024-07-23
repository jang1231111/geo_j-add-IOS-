enum Filter {
  all,
  active,
  completed,
}

class SigninInfo {
  final Centerinfo centerInfo;
  final List<Device> deviceList;

  factory SigninInfo.initial() {
    return SigninInfo(
        centerInfo: Centerinfo(
            centerNm: '', centerSn: 0, managerPn: '', getDeviceListUri: ''),
        deviceList: []);
  }

  SigninInfo({required this.centerInfo, required this.deviceList});

  @override
  String toString() =>
      'SigninInfo(centerInfo: $centerInfo, deviceList: $deviceList)';

  SigninInfo copyWith({
    Centerinfo? centerInfo,
    List<Device>? deviceList,
  }) {
    return SigninInfo(
      centerInfo: centerInfo ?? this.centerInfo,
      deviceList: deviceList ?? this.deviceList,
    );
  }
}

class Centerinfo {
  final int centerSn;
  final String centerNm;
  final String managerPn;
  final String getDeviceListUri;

  Centerinfo(
      {required this.centerSn,
      required this.centerNm,
      required this.managerPn,
      required this.getDeviceListUri});

  factory Centerinfo.fromJson(Map<String, dynamic> json) {
    return Centerinfo(
        centerSn: json['centerSn'],
        centerNm: json['centerNm'],
        managerPn: json['managerPn'],
        getDeviceListUri:
            "http://${json['ip']}:${json['loginPort']}/box/${json['appType']}");
  }

  Centerinfo copyWith({
    String? centerName,
    int? centerSn,
    String? managerPn,
    String? getDeviceUri,
  }) {
    return Centerinfo(
      centerNm: centerName ?? this.centerNm,
      centerSn: centerSn ?? this.centerSn,
      managerPn: managerPn ?? this.managerPn,
      getDeviceListUri: getDeviceUri ?? this.getDeviceListUri,
    );
  }

  @override
  String toString() {
    return 'Centerinfo(centerSn: $centerSn, centerNm: $centerNm, managerPn: $managerPn, getDeviceListUri: $getDeviceListUri)';
  }
}

class Device {
  final int shippingSeq;
  final String boxName;
  final String deNumber;
  final String destination;
  final int transportState;
  final String dbNm;
  final int tempLow;
  final int tempHigh;
  final DateTime arrivalTime;
  final String datetime;

  Device(
      {required this.shippingSeq,
      required this.boxName,
      required this.deNumber,
      required this.destination,
      required this.transportState,
      required this.dbNm,
      required this.tempLow,
      required this.tempHigh,
      required this.arrivalTime,
      required this.datetime});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
        shippingSeq: json['shippingSeq'],
        boxName: json['boxName'],
        deNumber: json['deNumber'],
        destination: json['destination'],
        transportState: json['transportState'],
        dbNm: json['dbNm'],
        tempLow: json['tempLow'],
        tempHigh: json['tempHigh'],
        arrivalTime: DateTime.parse(json['arrivalTime']),
        datetime: json['datetime']);
  }

  @override
  String toString() {
    return 'Device(shippingSeq: $shippingSeq, boxName: $boxName, deNumber: $deNumber, destination: $destination, transportState: $transportState, dbNm: $dbNm, tempLow: $tempLow, tempHigh: $tempHigh, arrivalTime: $arrivalTime, datetime: $datetime)';
  }

  Device copyWith({
    int? shippingSeq,
    String? boxName,
    String? deNumber,
    String? destination,
    int? transportState,
    String? dbNm,
    int? tempLow,
    int? tempHigh,
    DateTime? arrivalTime,
    String? datetime,
  }) {
    return Device(
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
    );
  }
}