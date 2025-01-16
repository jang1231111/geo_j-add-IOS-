import 'package:flutter/material.dart';
import 'package:geo_j/models/error/custom_error.dart';
import 'package:geo_j/pages/scan_page.dart';
import 'package:geo_j/providers/signin/signin_provider.dart';
import 'package:geo_j/utils/error_dialog.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
  
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        try {
          // await context.read<SigninProvider>().signin();
          Navigator.pushNamed(context, ScanPage.routeName);
        } on CustomError catch (e) {
          errorDialog(context, e.toString());
        }
      },
    );

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
