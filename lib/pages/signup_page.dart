import 'package:flutter/material.dart';
import 'package:geo_j/constants/style.dart';
import 'package:geo_j/pages/signin_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static const String routeName = '/signup';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     '문의하기',
        //   ),
        // ),
        body: SafeArea(
          child: Container(
            color: Color.fromARGB(255, 240, 240, 246),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            '문의하기 전 확인해주세요.',
                            style: question_title(context),
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 1,
                          //     blurRadius: 7,
                          //     offset: Offset(0, 3), // changes position of shadow
                          //   ),
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '로그인에 실패합니다.',
                                style: question_subtitle1(context),
                              ),
                              Text(
                                '1. 전화번호를 확인해주세요.',
                                style: question_subtitle2(context),
                              ),
                              Text(
                                '배정받는 전화번호는 11자리로 구성되며 모두 숫자로 구성됩니다.',
                                style: question_detail(context),
                              ),
                              Text(
                                '2. 로그인 후에 다시 로그인 화면으로 되돌아 옵니다.',
                                style: question_subtitle2(context),
                              ),
                              Text(
                                '위치 서비스를 활성화 해주세요.',
                                style: question_detail(context),
                              ),
                              Text(
                                '- [설정] -> [개인정보 보호 및 보안] -> [위치 서비스] 활성화',
                                style: question_detail(context),
                              ),
                              Text(
                                '앱 권한을 허용해주세요.',
                                style: question_detail(context),
                              ),
                              Text(
                                '- [설정] -> [Geo_J] -> [블루투스, 위치] 활성화',
                                style: question_detail(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '배송건이 수정되지 않습니다.',
                                style: question_subtitle1(context),
                              ),
                              Text(
                                '1. 인터넷 상태를 확인해주세요.',
                                style: question_subtitle2(context),
                              ),
                              Text(
                                '- 신호가 미약한 곳일 경우, 다른 장소에서 재시도 해주세요.',
                                style: question_detail(context),
                              ),
                              Text(
                                '- 문제가 계속 될 경우, 관리자에게 문의해주시기 바랍니다.',
                                style: question_detail(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton.icon(
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
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 1,
                          //     blurRadius: 7,
                          //     offset: Offset(0, 3), // changes position of shadow
                          //   ),
                          // ],
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
