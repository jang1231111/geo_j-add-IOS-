import 'package:flutter/material.dart';
import 'package:geo_j/constants/style.dart';
import 'package:geo_j/models/device/device_logdata_info.dart';
import 'package:geo_j/models/login/signin_info.dart';
import 'package:geo_j/providers/device_log_data/device_log_data_provider.dart';
import 'package:geo_j/providers/device_log_data/device_log_data_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailPage extends StatelessWidget {
  static const String routeName = '/detail';

  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          color: Color.fromARGB(255, 240, 240, 246),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  DetailHeader(),
                  SizedBox(
                    child: Divider(
                      height: 5,
                    ),
                    height: 20,
                  ),
                  Text(
                    'temperatureGraph',
                    style: TextStyle(
                        color: Color.fromARGB(255, 38, 94, 176),
                        fontSize: 15.0),
                  ),
                  dataChart(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'temperatureDataDetail',
                    style: TextStyle(
                        color: Color.fromARGB(255, 38, 94, 176),
                        fontSize: 15.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(flex: 2, child: logInformation()),
                  SizedBox(
                    child: Divider(height: 5),
                    height: 20,
                  ),
                  Expanded(flex: 1, child: OptiloInfo()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // A10 device = ModalRoute.of(context)!.settings.arguments as A10;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'detailInfo',
          style: TextStyle(fontSize: 25.0),
        ),
        Text(
          // 'DSIT - ${device.deNumber}',
          'DSIT - 테스트',
          style: TextStyle(
            fontSize: 15.0,
            color: Color.fromARGB(255, 241, 140, 31),
          ),
        )
      ],
    );
  }
}

class dataChart extends StatelessWidget {
  const dataChart({super.key});

  @override
  Widget build(BuildContext context) {
    DeviceLogDataState deviceLogDataState =
        context.watch<DeviceLogDataProvider>().state;

    return SfCartesianChart(
      primaryYAxis: NumericAxis(
          maximum: 40,
          interval: 5,
          minimum: -10,
          plotBands: <PlotBand>[
            PlotBand(
              horizontalTextAlignment: TextAnchor.end,
              shouldRenderAboveSeries: false,
              text: '-10°C',
              textStyle: TextStyle(
                  color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
              isVisible: true,
              start: -10,
              end: -10,
              borderWidth: 2,
              borderColor: Colors.red,
            ),
            PlotBand(
              horizontalTextAlignment: TextAnchor.end,
              shouldRenderAboveSeries: false,
              text: '40°C',
              textStyle: TextStyle(
                  color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
              isVisible: true,
              start: 40,
              end: 40,
              borderWidth: 2,
              borderColor: Colors.red,
            )
          ]),
      primaryXAxis: DateTimeAxis(
          // dateFormat: DateFormat.Hm(),
          dateFormat: DateFormat("MM-dd HH:mm"),
          labelRotation: 2,
          maximumLabels: 5,
          // Set name for x axis in order to use it in the callback event.
          name: 'primaryXAxis',
          intervalType: DateTimeIntervalType.hours,
          majorGridLines: MajorGridLines(width: 1)),
      legend: Legend(isVisible: false),
      // Enable tooltip
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <LineSeries<LogData, DateTime>>[
        LineSeries<LogData, DateTime>(
          // Bind data source
          dataSource: deviceLogDataState.logDatas,
          xValueMapper: (LogData logData, _) => logData.timeStamp,
          yValueMapper: (LogData logData, _) => logData.temperature,
          name: '온도 데이터',
        )
      ],
    );
  }
}

class logInformation extends StatelessWidget {
  const logInformation({super.key});

  @override
  Widget build(BuildContext context) {
    DeviceLogDataState deviceLogDataState =
        context.watch<DeviceLogDataProvider>().state;

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            'Serial No',
                            textAlign: TextAlign.center,
                            style: subTitle(context),
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            '${deviceLogDataState.a10.deNumber}',
                            textAlign: TextAlign.center,
                            style: subTitle(context),
                          ))
                    ],
                  ),
                ),
                // Expanded(
                //   flex: 1,
                //   child:
                // Row(
                //   children: [
                // Expanded(
                //   flex: 1,
                //   child: Text(
                //     'startTime',
                //     textAlign: TextAlign.center,
                //     style: subTitle(context),
                //   ),
                // ),
                // Expanded(
                //     flex: 1,
                //     child: Padding(
                //       padding: const EdgeInsets.all(2.0),
                //       child: ElevatedButton(
                //         onPressed: () async {
                //           await showDatePicker(
                //             context: context,
                //             initialDate: startDateTime,
                //             firstDate: DateTime.now()
                //                 .subtract(Duration(days: 30)),
                //             lastDate: DateTime.now(),
                //           ).then(
                //             (DateTime? startDate) {
                //               if (startDate != null) {
                //                 startDateTime = startDate;
                //               }
                //             },
                //           );

                //           await showTimePicker(
                //             context: context,
                //             initialTime: TimeOfDay(
                //                 hour: startDateTime.hour,
                //                 minute: startDateTime.minute),
                //           ).then(
                //             (TimeOfDay? startTime) {
                //               if (startTime != null) {
                //                 final newStartTime = DateTime(
                //                     startDateTime.year,
                //                     startDateTime.month,
                //                     startDateTime.day,
                //                     startTime.hour,
                //                     startTime.minute);

                //                 startDateTime = newStartTime;
                //               }
                //               setState(() {});
                //             },
                //           );
                //         },
                //         child: Text(
                //           DateFormat("MM-dd HH:mm").format(startDateTime),
                //           textAlign: TextAlign.center,
                //           style: subTitle(context),
                //         ),
                //       ),
                //     )),
                //   ],
                // ),
                // ),
                // Expanded(
                //   flex: 1,
                //   child: Row(
                //     children: [
                //       Expanded(
                //           flex: 1,
                //           child: Text(
                //             'endTime',
                //             textAlign: TextAlign.center,
                //             style: subTitle(context),
                //           )),
                //       Expanded(
                //         flex: 1,
                //         child: Padding(
                //           padding: const EdgeInsets.all(2.0),
                //           child: ElevatedButton(
                //             onPressed: () async {
                //               await showDatePicker(
                //                 context: context,
                //                 initialDate: endDateTime,
                //                 firstDate:
                //                     DateTime.now().subtract(Duration(days: 30)),
                //                 lastDate: DateTime.now(),
                //               ).then(
                //                 (DateTime? endDate) {
                //                   if (endDate != null) {
                //                     endDateTime = endDate;
                //                   }
                //                 },
                //               );

                //               await showTimePicker(
                //                 context: context,
                //                 initialTime: TimeOfDay(hour: 22, minute: 10),
                //               ).then(
                //                 (TimeOfDay? endDate) {
                //                   if (endDate != null) {
                //                     final newEndTime = DateTime(
                //                         endDateTime.year,
                //                         endDateTime.month,
                //                         endDateTime.day,
                //                         endDate.hour,
                //                         endDate.minute);

                //                     endDateTime = newEndTime;
                //                   }
                //                   setState(() {});
                //                 },
                //               );
                //             },
                //             child: Text(
                //               DateFormat("MM-dd HH:mm").format(endDateTime),
                //               textAlign: TextAlign.center,
                //               style: subTitle(context),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    'maxTemp',
                                    textAlign: TextAlign.center,
                                    style: subTitle(context),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${deviceLogDataState.logDatas.reduce((a, b) => a.temperature > b.temperature ? a : b).temperature}°C',
                                    textAlign: TextAlign.center,
                                    style: subTitle(context),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    'minTemp',
                                    textAlign: TextAlign.center,
                                    style: subTitle(context),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${deviceLogDataState.logDatas.reduce((a, b) => a.temperature < b.temperature ? a : b).temperature}°C',
                                    textAlign: TextAlign.center,
                                    style: subTitle(context),
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    'maxHum',
                                    textAlign: TextAlign.center,
                                    style: subTitle(context),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${deviceLogDataState.logDatas.reduce((a, b) => a.humidity > b.humidity ? a : b).humidity}%',
                                    textAlign: TextAlign.center,
                                    style: subTitle(context),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    'minHum',
                                    textAlign: TextAlign.center,
                                    style: subTitle(context),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${deviceLogDataState.logDatas.reduce((a, b) => a.humidity > b.humidity ? a : b).humidity}%',
                                    textAlign: TextAlign.center,
                                    style: subTitle(context),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        // Expanded(
        //   flex: 1,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 8),
        //     child: Container(
        //       width: double.infinity,
        //       child: ElevatedButton(
        //           style: TextButton.styleFrom(
        //             backgroundColor: Color.fromARGB(255, 38, 94, 176),
        //             foregroundColor: Colors.white,
        //             textStyle: TextStyle(
        //               fontSize: 15.0,
        //             ),
        //           ),
        //           onPressed: () {
        //             // A10 newDevice = device.copyWith(
        //             //   startTime: DateTime.utc(device.timeStamp.year,
        //             //       device.timeStamp.month, device.timeStamp.day),
        //             // );

        //             // A10 newDevice = device.copyWith(
        //             //     startTime: startDateTime, endTime: endDateTime);

        //             // final selectedCenterInfo = context
        //             //     .read<CenterListProvider>()
        //             //     .state
        //             //     .loginInfo;

        //             // try {
        //             //   A10 newDevice = device.copyWith(
        //             //       startTime: startDateTime.toUtc(),
        //             //       timeStamp: endDateTime.toUtc());

        //             //   context
        //             //       .read<DeviceLogDataProvider>()
        //             //       .getDeviceLogData(
        //             //           device: newDevice,
        //             //           token: selectedCenterInfo.token,
        //             //           company: selectedCenterInfo.company);
        //             // } on CustomError catch (e) {
        //             //   errorDialog(context, e.toString());
        //             // }
        //           },
        //           child: Text('select')),
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 2,
        ),
      ],
    );
  }
}

class OptiloInfo extends StatelessWidget {
  const OptiloInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(4, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '(주)옵티로',
            style: optilo_name(context),
          ),
          Text(
            '인천광역시 연수구 송도미래로30 스마트밸리 D동',
            style: optilo_info(context),
          ),
          Text(
            'H: www.optilo.net T: 070-5143-8585',
            style: optilo_info(context),
          ),
        ],
      ),
    );
  }
}
