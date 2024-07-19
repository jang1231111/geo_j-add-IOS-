import 'package:flutter/material.dart';
import 'package:geo_j/pages/signin_page.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});
  static const String routeName = '/scan';

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.pushNamed(context, SigninPage.routeName);
      },
    );

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
