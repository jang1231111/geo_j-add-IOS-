import 'package:flutter/material.dart';
import 'package:geo_j/models/custom_error.dart';
import 'package:geo_j/pages/scan_page.dart';
import 'package:geo_j/pages/signup_page.dart';
import 'package:geo_j/pages/support_page.dart';
import 'package:geo_j/providers/signin/signin_provider.dart';
import 'package:geo_j/providers/signin/signin_state.dart';
import 'package:geo_j/providers/user/user_provider.dart';
import 'package:geo_j/utils/error_dialog.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});
  static const String routeName = '/signin';

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _phoneNumber;

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    form.save();

    try {
      await context.read<UserProvider>().fetchUsers();
      final users = await context.read<UserProvider>().users;

      final phoneNumber = _phoneNumber!.replaceAll('-', '');
      final isUserExist = users.any((user) {
        print('user: ${user.phone}  , phone : ${phoneNumber}');
        return user.phone == phoneNumber;
      });

      print('isUserExist : ${isUserExist}');

      if (isUserExist) {
        // 내부 DB 검색 성공 시, 다음 동작 수행
        Navigator.pushNamed(context, ScanPage.routeName, arguments: '내부DB');
      } else {
        // 사용자 정보가 없는 경우 CustomError 발생
        throw CustomError(errMsg: '전화번호를 확인해주세요.');
      }
    } on CustomError catch (e) {
      try {
        print(e.toString());
        await context.read<SigninProvider>().signin(phoneNumber: _phoneNumber!);
        Navigator.pushNamed(context, ScanPage.routeName);
      } on CustomError catch (error) {
        errorDialog(context, error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final signinState = context.watch<SigninProvider>().state;

    return PopScope(
      canPop: false,
      child: GestureDetector(
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
                    Image.asset(
                      'assets/images/background.jpeg',
                      width: 250,
                      height: 250,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      maxLength: 11,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return '전화번호를 입려하세요';
                        }
                        if (value.trim().length < 11)
                          return '전화번호는 11자리 전체를 입력해야 합니다.';
                        return null;
                      },
                      onSaved: (String? inputPhoneNumber) {
                        String phoneNumber = '';
                        phoneNumber += inputPhoneNumber!.substring(0, 3);
                        phoneNumber += '-';
                        phoneNumber += inputPhoneNumber.substring(3, 7);
                        phoneNumber += '-';
                        phoneNumber += inputPhoneNumber.substring(7, 11);

                        _phoneNumber = phoneNumber;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed:
                          signinState.signinStatus == SigninStatus.submitting
                              ? null
                              : _submit,
                      child: Text(
                          signinState.signinStatus == SigninStatus.submitting
                              ? 'Loading...'
                              : 'Sign in'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextButton.icon(
                      onPressed:
                          signinState.signinStatus == SigninStatus.submitting
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                      context, SignUpPage.routeName);
                                },
                      icon: Icon(Icons.person_add),
                      label: Text('회원 가입'),
                      style: TextButton.styleFrom(
                          textStyle: TextStyle(
                        fontSize: 20.0,
                        // decoration: TextDecoration.underline,
                      )),
                    ),
                    SizedBox(height: 5.0),
                    TextButton.icon(
                      onPressed:
                          signinState.signinStatus == SigninStatus.submitting
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                      context, SupportPage.routeName);
                                },
                      icon: Icon(Icons.question_answer),
                      label: Text('관리자에게 문의하기'),
                      style: TextButton.styleFrom(
                          textStyle: TextStyle(
                        fontSize: 20.0,
                        // decoration: TextDecoration.underline,
                      )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
