import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geo_j/pages/scan_page.dart';
import 'package:geo_j/pages/signin_page.dart';
import 'package:geo_j/pages/splash_page.dart';
import 'package:geo_j/providers/device_filter/device_filter_provider.dart';
import 'package:geo_j/providers/device_search/device_search_provider.dart';
import 'package:geo_j/providers/filtered_devices/filtered_devices_provider.dart';
import 'package:geo_j/providers/signin/signin_provider.dart';
import 'package:geo_j/repositories/logdata_repositories.dart';
import 'package:geo_j/repositories/signin_repositories.dart';
import 'package:geo_j/services/api_services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SigninRepositories>(
          create: (context) => SigninRepositories(
            apiServices: ApiServices(
              httpClient: http.Client(),
            ),
          ),
        ),
        Provider<LogdataRepositories>(
          create: (context) => LogdataRepositories(
            apiServices: ApiServices(
              httpClient: http.Client(),
            ),
          ),
        ),
        ChangeNotifierProvider<SigninProvider>(
          create: (context) => SigninProvider(
            signinRepositories: context.read<SigninRepositories>(),
          ),
        ),
        ChangeNotifierProvider<DeviceFilterProvider>(
          create: (context) => DeviceFilterProvider(),
        ),
        ChangeNotifierProvider<DeviceSearchProvider>(
          create: (context) => DeviceSearchProvider(),
        ),
        ProxyProvider3<SigninProvider, DeviceFilterProvider,
            DeviceSearchProvider, FilteredDevicesProvider>(
          update: (
            BuildContext context,
            SigninProvider signinProvider,
            DeviceFilterProvider deviceFilterProvider,
            DeviceSearchProvider deviceSearchProvider,
            FilteredDevicesProvider? _,
          ) =>
              FilteredDevicesProvider(
                  deviceFilterProvider: deviceFilterProvider,
                  deviceSearchProvider: deviceSearchProvider,
                  signinProvider: signinProvider),
        )
      ],
      child: MaterialApp(
        title: 'GEO_J',
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
        routes: {
          SigninPage.routeName: (context) => SigninPage(),
          ScanPage.routeName: (context) => ScanPage(),
        },
      ),
    );
  }
}
