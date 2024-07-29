import 'dart:typed_data';

import 'package:geo_j/models/log_data.dart';

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
