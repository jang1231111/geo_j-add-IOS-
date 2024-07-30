import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/log_data.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/providers/signin/signin_provider.dart';
import 'package:geo_j/repositories/logdata_repositories.dart';
import 'package:geo_j/utils/convert.dart';
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

/// NOTIFY
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
