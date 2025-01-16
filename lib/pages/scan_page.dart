import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geo_j/constants/style.dart';
import 'package:geo_j/models/login/signin_info.dart';
import 'package:geo_j/pages/signin_page.dart';
import 'package:geo_j/providers/device_filter/device_filter_provider.dart';
import 'package:geo_j/providers/device_search/device_search_provider.dart';
import 'package:geo_j/providers/filtered_devices/filtered_devices_provider.dart';
import 'package:geo_j/providers/scan_result/scan_result_provider.dart';
import 'package:geo_j/providers/signin/signin_provider.dart';
import 'package:geo_j/repositories/gps_data_repositories.dart';
import 'package:geo_j/utils/debounce.dart';
import 'package:geo_j/utils/bluetooth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:location/location.dart' as loc;
import 'package:wakelock/wakelock.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});
  static const String routeName = '/scan';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 20.0,
                vertical: 40.0,
              ),
              child: Column(
                children: [
                  ScanHeader(),
                  SizedBox(height: 20.0),
                  // SearchAndFilterDevice(),
                  ShowDevices(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScanHeader extends StatelessWidget {
  const ScanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '배송 목록',
          style: TextStyle(fontSize: 40.0),
        ),
        Text(
          // '스캔 개수: ${context.watch<ActiveShippingCountProvider>().state.activeShippingCount}건',
          '스캔 개수',
          style: TextStyle(fontSize: 20.0, color: Colors.black),
        )
      ],
    );
  }
}

class SearchAndFilterDevice extends StatelessWidget {
  SearchAndFilterDevice({super.key});
  final debounce = Debounce(millonseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Search Device',
            border: InputBorder.none,
            filled: true,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (String? newSearchTerm) {
            if (newSearchTerm != null) {
              debounce.run(
                () {
                  context
                      .read<DeviceSearchProvider>()
                      .setSearchTerm(newSearchTerm);
                },
              );
            }
          },
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            filterButton(context, Filter.all),
            filterButton(context, Filter.active),
            filterButton(context, Filter.completed),
          ],
        )
      ],
    );
  }

  Widget filterButton(BuildContext context, Filter filter) {
    return TextButton(
      onPressed: () {
        context.read<DeviceFilterProvider>().changeFilter(filter);
      },
      child: Text(
        filter == Filter.all
            ? '전체'
            : filter == Filter.active
                ? '배송 중'
                : '배송 완료',
        style: TextStyle(
          fontSize: 18.0,
          color: textColor(context, filter),
        ),
      ),
    );
  }

  Color textColor(BuildContext context, Filter filter) {
    final currentFilter = context.watch<DeviceFilterProvider>().state.filter;
    return currentFilter == filter ? Colors.blue : Colors.grey;
  }
}

class ShowDevices extends StatefulWidget {
  const ShowDevices({super.key});

  @override
  State<ShowDevices> createState() => _ShowDevicesState();
}

class _ShowDevicesState extends State<ShowDevices> {
  List<ScanResult>? scanResults;
  loc.Location location = loc.Location();
  loc.LocationData? _locationData;
  late Timer updateTimer;
  late Timer gpsTimer;
  late Timer scanTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Wakelock.enable();
      await enableLocationService();
      await permissionRequest();
      getCurrentLocation();
      startGpsTimer();
      scanListener();
      startUpdateTimer();
      startScanTimer();
    });
  }

  @override
  void dispose() {
    gpsTimer.cancel();
    scanTimer.cancel();
    updateTimer.cancel();
    super.dispose();
  }

  Future<void> enableLocationService() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      Navigator.pushNamed(context, SigninPage.routeName);
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  Future<void> permissionRequest() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetooth,
    ].request();

    if (statuses.values.every((element) => element.isGranted)) {
      return;
    }

    await openAppSettings();
    Navigator.pushNamed(context, SigninPage.routeName);
  }

  getCurrentLocation() async {
    location.onLocationChanged.listen((loc.LocationData tempcurrentLocation) {
      _locationData = tempcurrentLocation;

      /// DebugLog
      // print('lng: ' + tempcurrentLocation.longitude.toString());
      // print('lat: ' + tempcurrentLocation.latitude.toString());
    });
  }

  void startGpsTimer() {
    const duration = const Duration(minutes: 5);
    // const duration = const Duration(seconds: 5);
    gpsTimer = Timer.periodic(
      duration,
      (timer) {
        SigninInfo signinInfo = context.read<SigninProvider>().state.signinInfo;
        context
            .read<GpsDataRepositories>()
            .sendGpsData(_locationData, signinInfo);
      },
    );
  }

  void scanListener() {
    var subscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          scanResults = results;
        }
      },
      onError: (e) => print(e),
    );

    FlutterBluePlus.cancelWhenScanComplete(subscription);
  }

  startUpdateTimer() async {
    const duration = const Duration(seconds: 10);

    updateTimer = Timer.periodic(
      duration,
      (_) async {
        if (scanResults != null) {
          // context.read<ScanResultProvider>().updateScanResult(scanResults!);

          List<ScanResult> lastScanResults = [];
          lastScanResults.addAll(scanResults!);

          for (int i = 0; i < lastScanResults.length; i++) {
            ScanResult scanResult = lastScanResults[i];
            Uint8List advertiseData = Uint8List.fromList(
                scanResult.advertisementData.manufacturerData.values.first);

            /// Serial 6 자리  ex)1903CE
            String serial1 = advertiseData[5].toRadixString(16).padLeft(2, '0');
            String serial2 = advertiseData[6].toRadixString(16).padLeft(2, '0');
            String serial3 = advertiseData[7].toRadixString(16).padLeft(2, '0');
            String serial = serial1 + serial2 + serial3;

            bool isDataUpdate = context.read<SigninProvider>().updateAdvertise(
                  serial: serial,
                  advertiseData: advertiseData,
                );

            /// 자동 데이터 전송 임시 주석 처리
            // if (isDataUpdate) {
            //   StreamSubscription<BluetoothConnectionState>? subscription;
            //   try {
            //     subscription = bleStateListener(context, scanResult, serial);

            //     /// 미연결 상태일 경우에만 연결 시도
            //     if (scanResult.device.isDisconnected) {
            //       await scanResult.device
            //           .connect(timeout: Duration(seconds: 8));
            //     }

            //     /// 연결중일 경우, 연결만 해제
            //     /// 재연결 안하는 이유: 블루투스 오류 방지를 위해, 한 주기(UpdateTimer : 10초) 쉬고 다음번 루틴 때 연결 처리
            //     else {
            //       await scanResult.device.disconnect();
            //       subscription.cancel();
            //     }
            //   } catch (e) {
            //     print(
            //         '기기 연결 BleException : ${e.toString()}  시간 : ${DateTime.now()}');
            //     subscription!.cancel();
            //   }
            //   break;
            // } else {
            //   continue;
            // }
          }
        }
      },
    );
  }

  startScanTimer() async {
    const duration = const Duration(minutes: 1);

    scanTimer = Timer.periodic(
      duration,
      (_) async {
        await FlutterBluePlus.stopScan();
        await FlutterBluePlus.startScan(
            timeout: const Duration(minutes: 10),
            withNames: [
              'T301',
              'T305',
              'T306',
            ]);

        /// 상태관리 사용으로 인해, UI 리빌드가 필요할때를 제외하고 발생하지 않음
        /// DateTime (파란불,빨간불) 이 시간이 지나도 상태관리를 이용한 변환이 없을시 리빌드가 이루어지지 않으므로 스캔 재시작 시마다 화면을 새로 그려준다
        setState(() {});
      },
    );

    // 첫 초기화, 스캔 시작
    await FlutterBluePlus.startScan(
        timeout: const Duration(minutes: 10),
        withNames: [
          'T301',
          'T305',
          'T306',
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final filteredDevices =
        context.watch<FilteredDevicesProvider>().state.filteredDevices;

    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: filteredDevices.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return DeviceItem(device: filteredDevices[index]);
      },
    );
  }
}

class DeviceItem extends StatefulWidget {
  final A10 device;
  const DeviceItem({super.key, required this.device});

  @override
  State<DeviceItem> createState() => _DeviceItemState();
}

class _DeviceItemState extends State<DeviceItem> {
  bool connecting = false;
  late List<ScanResult> scanResults;

  @override
  void initState() {
    super.initState();

    // scanResults = context.read<ScanResultProvider>().state.scanResuls;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(children: [
        Expanded(
          flex: 5,
          child: Container(
            // padding: EdgeInsets.only(top: 5, bottom: 4, left: 2),
            width: MediaQuery.of(context).size.width * 0.98,
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 18.0,
                    spreadRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                      padding: EdgeInsets.only(top: 3, left: 10, right: 10),
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(201, 201, 201, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            //MAC어드레스 번호
                            onTap: () async {},
                            child: Text(
                              widget.device.deNumber,
                              style: macName(context),
                            ),
                          ),
                          getbatteryImage(context, widget.device.battery),
                        ],
                      )),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      width: MediaQuery.of(context).size.width * 1,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            //시작시간,
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //시작시간:

                                Text('시작시간',
                                    style: startText(context),
                                    textAlign: TextAlign.start),
                                // device.arrivalTime != null
                                //     ? Text(
                                //         DateFormat('yyyy-MM-dd HH:mm')
                                //             .format(device.arrivalTime),
                                //         style: startTime(context),
                                //       )
                                //     :
                                Text(
                                  '시작 버튼을 눌러주세요.',
                                  style: startTime(context),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            //온도계이미지, 온도데이터
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image:
                                      AssetImage('assets/images/temp_ic.png'),
                                  fit: BoxFit.contain,
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    '${widget.device.temperature}°C',
                                    style: temp(context),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                Expanded(
                  flex: 3,
                  child: Row(children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Color.fromRGBO(222, 222, 222, 1),
                                    width: 0.7),
                                right: BorderSide(
                                    color: Color.fromRGBO(222, 222, 222, 1),
                                    width: 0.7))),
                        child: TextButton(
                          onPressed: () {
                            // 확인용 Dialog
                            // int result ƒ= await EndYesOrNoDialog(context);
                            // if (result == 1) {
                            context
                                .read<FilteredDevicesProvider>()
                                .updateStartTime(widget.device);
                            // }ƒ
                          },
                          child: widget.device.startTime != null
                              ? Text('온도 수집 중', style: startButton2(context))
                              : Text('시 작', style: startButton(context)),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          // width:MediaQuery.of(context).size.width*0.5,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            // border: Border(top: BorderSide(
                            //     color: Color.fromRGBO(222,222,222, 1),
                            //     width:0.7),right: BorderSide(color:Color.fromRGBO(222,222,222, 1),width: 0.7))
                          ),

                          child: TextButton(
                              onPressed: () async {
                                // widget.device.startTime == null
                                //     ? () {
                                //         // Err Dialog
                                //         // showMyDialog_ShipFinish_Error(context2);
                                //       }
                                //     : () async {
                                if (!connecting) {
                                  StreamSubscription<BluetoothConnectionState>?
                                      subscription;
                                  try {
                                    ScanResult scanResult;

                                    for (var i = 0;
                                        i < scanResults.length;
                                        i++) {
                                      Uint8List advertiseData =
                                          Uint8List.fromList(scanResults[i]
                                              .advertisementData
                                              .manufacturerData
                                              .values
                                              .first);

                                      /// Serial 6 자리  ex)1903CE
                                      String serial1 = advertiseData[5]
                                          .toRadixString(16)
                                          .padLeft(2, '0');
                                      String serial2 = advertiseData[6]
                                          .toRadixString(16)
                                          .padLeft(2, '0');
                                      String serial3 = advertiseData[7]
                                          .toRadixString(16)
                                          .padLeft(2, '0');
                                      String serial =
                                          serial1 + serial2 + serial3;

                                      if (widget.device.deNumber == serial) {
                                        scanResult = scanResults[i];

                                        /// 데이터 연결 루틴 시작
                                        subscription = bleStateListener(
                                            context, scanResult, serial);

                                        /// 미연결 상태일 경우에만 연결 시도
                                        if (scanResult.device.isDisconnected) {
                                          await scanResult.device.connect(
                                              timeout: Duration(seconds: 8));
                                          connecting = true;
                                        }

                                        /// 연결중일 경우, 연결만 해제
                                        /// 재연결 안하는 이유: 블루투스 오류 방지를 위해, 한 주기(UpdateTimer : 10초) 쉬고 다음번 루틴 때 연결 처리
                                        else {
                                          await scanResult.device.disconnect();
                                          subscription.cancel();
                                        }
                                      }
                                    }
                                  } catch (e) {
                                    print(
                                        '기기 연결 BleException : ${e.toString()}  시간 : ${DateTime.now()}');
                                    subscription!.cancel();
                                  }

                                  //////////

                                  // duration = 1;
                                  // connecting = true;
                                  // await connect(index, 0, 2);
                                  // endTime = new DateTime.now()
                                  //     .millisecondsSinceEpoch;
                                  // deferenceMillSeconds = endTime -
                                  //     deviceList[index].startTime;
                                }
                                // };
                              },
                              child: Text(
                                '일부  전송:',
                                style: startButton(context),
                              )
                              // deviceList[index].startTime == null
                              //     ? Text(
                              //         '일부  전송:' +
                              //             deviceList[index].sendcount.toString(),
                              //         style: endButton2(context),
                              //       )
                              //     : Text(
                              //         '일부  전송:' +
                              //             deviceList[index].sendcount.toString(),
                              //         style: startButton(context),
                              // ),
                              ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          // width:MediaQuery.of(context).size.width*0.5,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(63, 63, 63, 1),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15))),
                          child: TextButton(
                            onPressed: null,
                            // deviceList[index].startTime == null
                            //     ? () {
                            //         showMyDialog_ShipFinish_Error(context2);
                            //       }
                            //     : () async {
                            //         if (!connecting) {
                            //           connecting = true;
                            //           setState(() {
                            //             endtype1 = true;
                            //           });
                            //           duration = 1;
                            //           await connect(index, 0, 0);
                            //           endTime = new DateTime.now()
                            //               .millisecondsSinceEpoch;
                            //           deferenceMillSeconds =
                            //               endTime - deviceList[index].startTime;

                            //           print("종료를 눌렀다.================");
                            //         }
                            //       },
                            child: Text(
                              '종  료',
                              style: endButton(context),
                            ),
                            // deviceList[index].startTime == null
                            //     ? Text(
                            //         '종  료',
                            //         style: endButton2(context),
                            //       )
                            //     : Text(
                            //         '종  료',
                            //         style: endButton(context),
                            //       ),
                          ),
                        ))
                  ]),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
