import 'package:flutter/material.dart';
import 'package:geo_j/constants/style.dart';
import 'package:geo_j/models/signin_info.dart';
import 'package:geo_j/providers/device_filter/device_filter_provider.dart';
import 'package:geo_j/providers/device_search/device_search_provider.dart';
import 'package:geo_j/providers/filtered_devices/filtered_devices_provider.dart';
import 'package:geo_j/utils/debounce.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});
  static const String routeName = '/scan';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          // '${context.watch<ActiveTodoCountState>().activeTodoCount} items left',
          'Searching Device',
          style: TextStyle(fontSize: 20.0, color: Colors.black),
        )
      ],
    );
  }
}

class SearchAndFilterDevice extends StatelessWidget {
  SearchAndFilterDevice({super.key});
  final debounce = Debounce(millonseconds: 1000);

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
            ? 'All'
            : filter == Filter.active
                ? 'Active'
                : 'Completed',
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

class ShowDevices extends StatelessWidget {
  const ShowDevices({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceList =
        context.watch<FilteredDevicesProvider>().state.filteredDevices;
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: deviceList.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return DeviceItem(device: deviceList[index]);
      },
    );
  }
}

class DeviceItem extends StatefulWidget {
  final Device device;

  const DeviceItem({super.key, required this.device});

  @override
  State<DeviceItem> createState() => _DeviceItemState();
}

class _DeviceItemState extends State<DeviceItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: widget.device.transportState == 1
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
                              color: widget.device.transportState == 1
                                  ? const Color.fromRGBO(136, 136, 136, 1)
                                  : widget.device.arrivalTime.isBefore(
                                          DateTime.now().toLocal().subtract(
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
                                    widget.device.transportState == 2
                                        ? widget.device.destination + ' (회송)'
                                        : widget.device.destination,
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
                                    // String result;
                                    // result = await shipFinishDialog(
                                    //     context, deviceList[index], index);

                                    // if (result == 'success') {
                                    //   String resultFinishedText = '';

                                    //   resultFinishedText = '[' +
                                    //       deviceList[index].destName +
                                    //       '] ' +
                                    //       DateFormat('M월 d일 HH:mm:ss')
                                    //           .format(DateTime.now().toLocal())
                                    //           .toString() +
                                    //       ' 배송 종료';

                                    //   resultfinishedListTexts
                                    //       .add(resultFinishedText);

                                    //   deviceList[index].status = 1;
                                    //   for (int k = 0;
                                    //       k < userList.userDevices.length;
                                    //       k++) {
                                    //     if (userList.userDevices[k].deNumber
                                    //             .substring(11) ==
                                    //         deviceList[index].serialNumber) {
                                    //       setState(() {
                                    //         // userList.userDevices.removeAt(k);
                                    //         userList.userDevices[k].status = 1;
                                    //         deviceList[index].status = 1;
                                    //       });
                                    //       break;
                                    //     }
                                    //   }
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
                            widget.device.boxName,
                            style: M_Name(context),
                          ),
                          widget.device.arrivalTime.isBefore(DateTime.now()
                                  .toLocal()
                                  .subtract(Duration(days: 200)))
                              ? Text(
                                  '최근 업로드 시간 : --일 --:--:--',
                                  style: UpLoad(context),
                                )
                              : Text(
                                  '최근 업로드 시간 : ' +
                                      DateFormat('d일 HH:mm:ss')
                                          .format(widget.device.arrivalTime),
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
                              child: Text(widget.device.transportState == 1
                                      ? '배송 완료'
                                      : 'strMapper'
                                  // strMapper(
                                  //     deviceList[index].connectionState),
                                  // style: widget.device.transportState == 1
                                  //     ? state_complete_green(context)
                                  //     : stateStyle(
                                  //         deviceList[index].connectionState),
                                  ),
                            ),
                          ),
                          Expanded(
                              flex: 13,
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Image.asset(
                                      'assets/images/flutter_logo.png',
                                      // 'assets/images/temp_ic.png',
                                      fit: BoxFit.fill),
                                  padding: const EdgeInsets.all(5))),
                          Expanded(
                              flex: 24,
                              child: Container(
                                  child: Text(
                                // deviceList[index].getTemperature().toString() +
                                '°C ',
                                style: Temp(context),
                              ))),
                          Expanded(
                              flex: 40,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // getbatteryImage(
                                    //     deviceList[index].getBattery()),
                                    // Text(
                                    //   '  ' +
                                    //       deviceList[index]
                                    //           .getBattery()
                                    //           .toString() +
                                    //       '%',
                                    // style: Temp(context),
                                    // ),
                                  ]))
                        ],
                      ))
                ],
              )),
        ],
      ),
    );
  }
}
