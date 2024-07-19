import 'package:flutter/material.dart';
import 'package:geo_j/pages/scan_page.dart';
import 'package:geo_j/pages/signin_page.dart';
import 'package:geo_j/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GEO_J',
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      routes: {
        SigninPage.routeName: (context) => SigninPage(),
        ScanPage.routeName: (context) => ScanPage(),
      },
    );
  }
}
