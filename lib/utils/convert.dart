import 'dart:typed_data';
import 'package:geo_j/models/device/device_logdata_info.dart';

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

LogData transformData(Uint8List notifyResult, int dataCount) {
  return LogData(
      temperature: getLogTemperature(notifyResult),
      humidity: getLogHumidity(notifyResult),
      timeStamp: getLogTime(notifyResult, dataCount));
}

DateTime getLogTime(Uint8List fetchData, int dataCount) {
  int tmp =
      ByteData.sublistView(fetchData.sublist(12, 16)).getInt32(0, Endian.big);

  // 펌웨어 시간값 변경 , 10분
  tmp = tmp - (9 * dataCount * 60);
  // 10분 단위로 나눌 시 나머지
  int remainder = tmp % (60 * 10);
  tmp = tmp - remainder;

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
