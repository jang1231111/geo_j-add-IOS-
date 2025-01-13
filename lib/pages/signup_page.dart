import 'package:flutter/material.dart';
import 'package:geo_j/constants/style.dart';
import 'package:geo_j/pages/signin_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static const String routeName = '/signup';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final phone = _phoneController.text;

      print('회원가입 정보: 이름: $name, 이메일: $email, 전화번호: $phone');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 완료!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Main Content Section
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      // Header Section
                      Column(
                        children: [
                          Icon(
                            Icons.account_circle,
                            size: 80,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(height: 10),
                          Text(
                            '회원가입 정보를 입력하세요.',
                            style: question_title(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      // Form Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: '이름',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '이름을 입력하세요.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: '이메일',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '이메일을 입력하세요.';
                                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return '유효한 이메일을 입력하세요.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  labelText: '전화번호',
                                  prefixIcon: Icon(Icons.phone),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '전화번호를 입력하세요.';
                                  } else if (!RegExp(r'^\d{10,11}$')
                                      .hasMatch(value)) {
                                    return '유효한 전화번호를 입력하세요. (10~11자리 숫자)';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 30),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _signUp,
                                  child: Text('회원가입'),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, SigninPage.routeName);
                          },
                          icon: Icon(Icons.login),
                          label: Text('로그인 하러가기'),
                          style: TextButton.styleFrom(
                              textStyle: TextStyle(
                            fontSize: 20.0,
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer Section (Fixed at Bottom)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
