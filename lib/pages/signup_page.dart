import 'package:flutter/material.dart';
import 'package:geo_j/constants/style.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static const String routeName = '/signup';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _name, _email, _password;
  final _passwordController = TextEditingController();

  // void _submit() async {
  //   setState(() {
  //     _autovalidateMode = AutovalidateMode.always;
  //   });

  //   final form = _formKey.currentState;

  //   if (form == null || !form.validate()) {
  //     return;
  //   }

  //   form.save();

  //   print('name : $_name, : $_email, password: $_password');

  //   try {
  //     await context
  //         .read<SignupProvider>()
  //         .signup(name: _name!, email: _email!, password: _password!);
  //   } on CustomError catch (e) {
  //     errorDialog(context, e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final signupState = context.watch<SignupProvider>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '(주)옵티로',
          style: optilo_name(context),
        ),
        Text(
          '인천광역시 연수구 송도미래로 30 스마트밸리 D동',
          style: optilo_info(context),
        ),
        Text(
          'H : www.optilo.net  T : 070-5143-8585',
          style: optilo_info(context),
        ),
      ],
    );
  }
}
