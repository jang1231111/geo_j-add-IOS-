import 'package:flutter/material.dart';

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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/flutter_logo.png',
                        width: 250,
                        height: 250,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        '옵티로',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        '주소',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        '전화번호',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        '문제 해결1',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        '문제 해결2',
                        style: TextStyle(fontSize: 20.0),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
