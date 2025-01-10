import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geo_j/models/error/custom_error.dart';
import 'package:geo_j/models/device/device_logdata_info.dart';
import 'package:geo_j/pages/detail_page.dart';
import 'package:geo_j/providers/device_log_data/device_log_data_provider.dart';
import 'package:geo_j/providers/signin/signin_provider.dart';
import 'package:geo_j/utils/convert.dart';
import 'package:provider/provider.dart';

// StateListener
StreamSubscription<BluetoothConnectionState> bleStateListener(
    BuildContext context, ScanResult scanResult, String deNumber) {
  BluetoothDevice device = scanResult.device;

  var subscription = device.connectionState.listen(
    (BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        // context
        //     .read<SigninProvider>()
        //     .updateBleState(serial: deNumber, bleState: '온도센서 스캔 중');
      }
      if (state == BluetoothConnectionState.connected) {
        // context
        //     .read<SigninProvider>()
        //     .updateBleState(serial: deNumber, bleState: '온도센서 연결 완료');

        var characteristic = await discoverCharacteristic(context, device);
        if (characteristic == null) {
          await device.disconnect();
        } else {
          writeCharacteristic(scanResult, characteristic);
        }
      }
    },
  );
  device.cancelWhenDisconnected(subscription, delayed: true, next: true);

  return subscription;
}

/// DISCOVER
Future<BluetoothCharacteristic?> discoverCharacteristic(
    BuildContext context, BluetoothDevice device) async {
  List<BluetoothService> services;

  try {
    services = await device.discoverServices();
  } catch (e) {
    print(
        'discoverCharacteristic Err : ${e.toString()}  시간 : ${DateTime.now()}');
    return null;
  }

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

  try {
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
  } catch (e) {
    print('writeCharacteristic Err : ${e.toString()}  시간 : ${DateTime.now()}');
    await scanResult.device.disconnect();
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
  int dataCount = 72;
  final subscription =
      notifyCharacteristic.onValueReceived.listen((notifyResult) async {
    if (notifyResult[10] == 0x03) {
      Uint8List minmaxIndex = getMinMaxIndex(Uint8List.fromList(notifyResult));

      int endStamp = threeBytesToint(minmaxIndex.sublist(3, 6));
      int startStamp = endStamp - dataCount;

      if (startStamp <= 0) {
        startStamp = 0;
      }

      Uint8List startIndex =
          Uint8List.fromList(convertInt2Bytes(startStamp, Endian.big, 3));
      Uint8List endindex = minmaxIndex.sublist(3, 6);

      try {
        writeCharacteristic.write(
          withoutResponse: true,
          Uint8List.fromList([0x55, 0xAA, 0x01, 0x06] +
              notifyResult.sublist(4, 10).reversed.toList() +
              [0x04, 0x06] +
              startIndex +
              endindex),
        );
      } catch (e) {
        print(
            'notifyStream03 Write Err : ${e.toString()}  시간 : ${DateTime.now()}');
        await device.disconnect();
      }
    }
    if (notifyResult[10] == 0x05) {
      LogData logData = transformData(
          Uint8List.fromList(
            notifyResult,
          ),
          dataCount--);
      logDatas.add(logData);
    }
    if (notifyResult[10] == 0x06) {
      DeviceLogDataProvider deviceLogDataProvider =
          context.read<DeviceLogDataProvider>();
      SigninProvider signinProvider = context.read<SigninProvider>();
      final devices = signinProvider.state.signinInfo.devices;

      /// Serial
      List<int> serials = notifyResult.sublist(4, 7).reversed.toList();
      String serial = '';
      for (int i = 0; i < serials.length; i++) {
        serial += serials[i].toRadixString(16).padLeft(2, '0');
      }

      /// 온도 데이터 전송
      try {
        await deviceLogDataProvider.sendLogData(
            serial: serial, logDatas: logDatas, devices: devices);

        Navigator.pushNamed(context, DetailPage.routeName);
      } on CustomError catch (e) {
        print('데이터 전송 실패 : ${e.toString()}');

        // /// 전송 실패
        // context
        //     .read<SigninProvider>()
        //     .updateBleState(serial: serial, bleState: '데이터 전송 실패');
      }

      /// 연결 종료
      await device.disconnect();
    }
  });

  device.cancelWhenDisconnected(subscription);

  try {
    await notifyCharacteristic.setNotifyValue(true);
  } catch (e) {
    print(
        'notifyStream setNotifyValue Err: ${e.toString()}   시간: ${DateTime.now()}');
  }
}
