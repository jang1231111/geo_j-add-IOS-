import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geo_j/constants/style.dart';
import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/pages/signin_page.dart';
import 'package:geo_j/providers/active_shipping_count/active_shipping_count_provider.dart';
import 'package:geo_j/providers/device_filter/device_filter_provider.dart';
import 'package:geo_j/providers/device_search/device_search_provider.dart';
import 'package:geo_j/providers/filtered_devices/filtered_devices_provider.dart';
import 'package:geo_j/providers/signin/signin_provider.dart';
import 'package:geo_j/repositories/gps_data_repositories.dart';
import 'package:geo_j/utils/debounce.dart';
import 'package:geo_j/utils/bluetooth.dart';
import 'package:geo_j/utils/error_dialog.dart';
import 'package:geo_j/widgets/shipping_dialog.dart';
import 'package:intl/intl.dart';
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
                  SearchAndFilterDevice(),
                  ShowDevices(),
                ],
              ),
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     await FlPiP().enable(
          //         ios: FlPiPiOSConfig(),
          //         android: FlPiPAndroidConfig(
          //             aspectRatio: const Rational.maxLandscape()));
          //   },
          // ),
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
          '남은 배송 건: ${context.watch<ActiveShippingCountProvider>().state.activeShippingCount}건',
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

            bool isUpdate = context.read<SigninProvider>().updateAdvertise(
                  serial: serial,
                  advertiseData: advertiseData,
                );

            if (isUpdate) {
              StreamSubscription<BluetoothConnectionState>? subscription;
              try {
                subscription = bleStateListener(context, scanResult, serial);

                /// 미연결 상태일 경우에만 연결 시도
                if (scanResult.device.isDisconnected) {
                  await scanResult.device
                      .connect(timeout: Duration(seconds: 8));
                }

                /// 연결중일 경우, 연결만 해제
                /// 재연결 안하는 이유: 블루투스 오류 방지를 위해, 한 주기(UpdateTimer : 10초) 쉬고 다음번 루틴 때 연결 처리
                else {
                  await scanResult.device.disconnect();
                  subscription.cancel();
                }
              } catch (e) {
                print(
                    '기기 연결 BleException : ${e.toString()}  시간 : ${DateTime.now()}');
                subscription!.cancel();
              }
              break;
            } else {
              continue;
            }
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

class DeviceItem extends StatelessWidget {
  final A10 device;
  const DeviceItem({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: device.transportState == 1
                    ? const Color.fromRGBO(179, 179, 179, 1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [mainbox()],
              ),
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 10,
                      child: Container(
                          decoration: BoxDecoration(
                              color: device.transportState == 1
                                  ? const Color.fromRGBO(136, 136, 136, 1)
                                  : device.datetime.isBefore(DateTime.now()
                                          .toLocal()
                                          .subtract(
                                              const Duration(minutes: 10)))
                                      ? const Color.fromRGBO(30, 135, 74, 1)
                                      : const Color.fromRGBO(227, 40, 53, 1),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height / 80)),
                  Expanded(
                      flex: 54,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 19,
                              child: SizedBox(
                                child: TextButton(
                                  onPressed: () async {
                                    // deStatus = await storage.readAll();
                                    // await destinationInfo(
                                    //     context,
                                    //     deviceList[index].destName,
                                    //     deviceList[index].boxName,
                                    //     deviceList[index].dbNm,
                                    //     deviceList[index].shippingSeq);
                                  },
                                  child: Text(
                                    device.transportState == 2
                                        ? device.destination + ' (회송)'
                                        : device.destination,
                                    style: Locate(context),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                              )),
                          Expanded(
                              //종료버튼
                              flex: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(235, 235, 235, 1),
                                    boxShadow: [mainbox()],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                margin: const EdgeInsets.all(7),
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () async {
                                    int? transportState;
                                    transportState =
                                        await shipFinishDialog(context, device);
                                    if (transportState != null) {
                                      try {
                                        print(transportState);
                                        await context
                                            .read<SigninProvider>()
                                            .updateTransportState(
                                                a10: device,
                                                transportState: transportState);
                                      } on CustomError catch (e) {
                                        errorDialog(context, e.toString());
                                      }
                                    }
                                  },
                                  child: Text('종료', style: boldTextStyle),
                                ),
                              ))
                        ],
                      )),
                  Expanded(
                    // 여기는 내용이 없어요 그냥 라인 만들라고 만든거에요
                    flex: 2,
                    child: Row(
                      // 중간line
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              height: 2,
                            )),
                        Expanded(
                            flex: 80,
                            child: Container(
                              color: Color.fromRGBO(235, 235, 235, 1),
                              height: 2,
                              width: MediaQuery.of(context).size.width * 1,
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              height: 2,
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 52,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            device.boxName,
                            style: M_Name(context),
                          ),
                          device.datetime.isBefore(DateTime.now()
                                  .toLocal()
                                  .subtract(Duration(days: 200)))
                              ? Text(
                                  '최근 업로드 시간 : --일 --:--:--',
                                  style: UpLoad(context),
                                )
                              : Text(
                                  '최근 업로드 시간 : ' +
                                      DateFormat('d일 HH:mm:ss')
                                          .format(device.datetime),
                                  style: lastUpdateTextStyle(context),
                                ),
                        ],
                      )),
                  Expanded(
                      //
                      flex: 56,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 48,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                device.transportState == 1
                                    ? '배송 완료'
                                    : device.bleState,
                                style: device.transportState == 1
                                    ? state_complete_green(context)
                                    : stateStyle(context, device.bleState),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 13,
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: device.temperature == -999
                                      ? Text('')
                                      : Image.asset(
                                          // 'assets/images/flutter_logo.png',
                                          'assets/images/temp_ic.png',
                                          fit: BoxFit.fill),
                                  padding: const EdgeInsets.all(5))),
                          Expanded(
                              flex: 24,
                              child: Container(
                                child: Text(
                                  device.temperature == -999
                                      ? ''
                                      : '${device.temperature}°C',
                                  style: Temp(context),
                                ),
                              )),
                          Expanded(
                            flex: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getbatteryImage(context, device.battery),
                                Text(
                                  device.battery == -999
                                      ? ''
                                      : '${device.battery}%',
                                  style: Temp(context),
                                )
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              )),
        ],
      ),
    );
  }
}
