import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/log_data.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/providers/signin/signin_provider.dart';
import 'package:geo_j/repositories/logdata_repositories.dart';
import 'package:provider/provider.dart';

// StateListener
void bleStateListener(
    BuildContext context, ScanResult scanResult, String deNumber) {
  BluetoothDevice device = scanResult.device;

  var subscription = device.connectionState.listen(
    (BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        print(
            "$deNumber Disconnected : ${device.disconnectReason?.code} ${device.disconnectReason?.description}");
      }
      if (state == BluetoothConnectionState.connected) {
        print(
            "$deNumber Connected : ${device.disconnectReason?.code} ${device.disconnectReason?.description}");

        var characteristic = await discoverCharacteristic(context, device);
        writeCharacteristic(scanResult, characteristic);
      }
    },
  );
  device.cancelWhenDisconnected(subscription, delayed: true, next: true);
}

/// DISCOVER
Future<BluetoothCharacteristic> discoverCharacteristic(
    BuildContext context, BluetoothDevice device) async {
  List<BluetoothService> services = await device.discoverServices();
  print('services : $services');

  BluetoothService service =
      services.firstWhere((service) => service.uuid.toString() == '1000');
  var characteristics = service.characteristics;

  BluetoothCharacteristic writeCharacteristic = characteristics
      .firstWhere((characteristic) => characteristic.uuid.toString() == '1001');

  BluetoothCharacteristic notifyCharacteristic = characteristics
      .firstWhere((characteristic) => characteristic.uuid.toString() == '1002');

  await notifyStream(
      context, device, notifyCharacteristic, writeCharacteristic);

  return writeCharacteristic;
}

/// WRITE
void writeCharacteristic(
    ScanResult scanResult, BluetoothCharacteristic characteristic) async {
  String name = scanResult.advertisementData.advName;
  Uint8List advertiseData = Uint8List.fromList(
      scanResult.advertisementData.manufacturerData.values.first);
  Uint8List macAdress = advertiseData.sublist(2, 8);

  // ignore: division_optimization
  String unixTimestamp = (DateTime.now().toUtc().millisecondsSinceEpoch / 1000)
      .toInt()
      .toRadixString(16);
  Uint8List timestamp = Uint8List.fromList([
    int.parse(unixTimestamp.substring(0, 2), radix: 16),
    int.parse(unixTimestamp.substring(2, 4), radix: 16),
    int.parse(unixTimestamp.substring(4, 6), radix: 16),
    int.parse(unixTimestamp.substring(6, 8), radix: 16),
  ]);

  if (name == 'T301') {
    await characteristic.write(
      Uint8List.fromList(
          [0x55, 0xAA, 0x01, 0x01] + macAdress + [0x02, 0x04] + timestamp),
    );
  } else if (name == 'T305') {
    await characteristic.write(
      Uint8List.fromList(
          [0x55, 0xAA, 0x01, 0x5] + macAdress + [0x02, 0x04] + timestamp),
    );
  } else if (name == 'T306') {
    await characteristic.write(
      withoutResponse: true,
      Uint8List.fromList(
          [0x55, 0xAA, 0x01, 0x6] + macAdress + [0x02, 0x04] + timestamp),
    );
  }
}

Uint8List getMinMaxIndex(Uint8List notifyResult) {
  return notifyResult.sublist(12, 18);
}

threeBytesToint(Uint8List temp) {
  int r = ((temp[0] & 0xF) << 16) | ((temp[1] & 0xFF) << 8) | (temp[2] & 0xFF);
  return r;
}

List<int> convertInt2Bytes(value, Endian order, int bytesSize) {
  try {
    final kMaxBytes = 4;
    var bytes = Uint8List(kMaxBytes)
      ..buffer.asByteData().setInt32(0, value, order);
    List<int> intArray;
    if (order == Endian.big) {
      intArray = bytes.sublist(kMaxBytes - bytesSize, kMaxBytes).toList();
    } else {
      intArray = bytes.sublist(0, bytesSize).toList();
    }
    return intArray;
  } catch (e) {
    throw Exception('convertInt2Bytes ERR');
  }
}

//Datalog Parsing
LogData transformData(Uint8List notifyResult) {
  return LogData(
      temperature: getLogTemperature(notifyResult),
      humidity: getLogHumidity(notifyResult),
      timeStamp: getLogTime(notifyResult));
}

DateTime getLogTime(Uint8List fetchData) {
  int tmp =
      ByteData.sublistView(fetchData.sublist(12, 16)).getInt32(0, Endian.big);

  DateTime time = DateTime.fromMillisecondsSinceEpoch(tmp * 1000, isUtc: true);

  return time;
}

double getLogHumidity(Uint8List fetchData) {
  int humidity =
      ByteData.sublistView(fetchData.sublist(18, 20)).getInt16(0, Endian.big);

  return humidity / 100;
}

double getLogTemperature(Uint8List fetchData) {
  int temperature =
      ByteData.sublistView(fetchData.sublist(16, 18)).getInt16(0, Endian.big);

  return temperature / 100;
}

//Notify
Future<void> notifyStream(
  BuildContext context,
  BluetoothDevice device,
  BluetoothCharacteristic notifyCharacteristic,
  BluetoothCharacteristic writeCharacteristic,
) async {
  final List<LogData> logDatas = [];
  final subscription =
      notifyCharacteristic.onValueReceived.listen((notifyResult) async {
    if (notifyResult[10] == 0x03) {
      Uint8List minmaxIndex = getMinMaxIndex(Uint8List.fromList(notifyResult));

      // int startIndex = threeBytesToint(minmaxIndex.sublist(0, 3));
      // int endIndex = threeBytesToint(minmaxIndex.sublist(3, 6));
      int tempstamp = threeBytesToint(minmaxIndex.sublist(3, 6)) - 20;

      // if (tempstamp <= 0) {
      //   tempstamp += (720 / interval).floor();
      // }

      // 데이터 개수 저장
      // int dataCount = endIndex - tempstamp;

      final startTest = convertInt2Bytes(tempstamp, Endian.big, 3);

      Uint8List startIndex = Uint8List.fromList(startTest);
      Uint8List endindex = minmaxIndex.sublist(3, 6);

      writeCharacteristic.write(
        withoutResponse: true,
        Uint8List.fromList([0x55, 0xAA, 0x01, 0x06] +
            notifyResult.sublist(4, 10).reversed.toList() +
            [0x04, 0x06] +
            startIndex +
            endindex),
      );
    }
    if (notifyResult[10] == 0x05) {
      print('notifyResult5 $notifyResult');

      LogData logData = transformData(Uint8List.fromList(notifyResult));
      print(logData);
      logDatas.add(logData);
    }
    if (notifyResult[10] == 0x06) {
      LogdataRepositories logdataRepositories =
          context.read<LogdataRepositories>();

      SigninInfo signinInfo = context.read<SigninProvider>().state.signinInfo;
      // 여기서 업데이트 타임 비교해서 기기 보내주기

      try {
        await logdataRepositories.sendLogData(
          notifyResult: notifyResult,
          signinInfo: signinInfo,
          logDatas: logDatas,
        );

        // 업로드 목록 추가
      } on CustomError catch (e) {
        e.toString();
        // 업로드 목록 추가 (에러 발생)
      }
    }
  });

  device.cancelWhenDisconnected(subscription);

  await notifyCharacteristic.setNotifyValue(true);
}
