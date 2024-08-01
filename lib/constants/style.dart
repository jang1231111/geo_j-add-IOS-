import 'package:flutter/material.dart';

TextStyle lastUpdateTextStyle(BuildContext context) {
  return TextStyle(
    fontFamily: 'pretend',
    fontSize: MediaQuery.of(context).size.width / 26,
    color: Color.fromRGBO(5, 5, 5, 1),
    fontWeight: FontWeight.w700,
  );
}

TextStyle updateTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: MediaQuery.of(context).size.width / 24,
    color: Color.fromRGBO(0xe8, 0x52, 0x55, 1),
    fontWeight: FontWeight.w500,
  );
}

TextStyle redBoldTextStyle = TextStyle(
  fontSize: 18,
  color: Color.fromRGBO(0xE0, 0x71, 0x51, 1),
  fontWeight: FontWeight.w900,
);
TextStyle boldTextStyle2 = TextStyle(
  fontSize: 13,
  color: Color.fromRGBO(21, 21, 21, 1),
  fontWeight: FontWeight.w800,
);
TextStyle boldTextStyle3 = TextStyle(
  fontSize: 30,
  color: Color.fromRGBO(21, 21, 21, 1),
  fontWeight: FontWeight.w800,
);
TextStyle boldTextStyle = TextStyle(
  fontSize: 22,
  color: Color.fromRGBO(21, 21, 21, 1),
  fontWeight: FontWeight.w800,
);
TextStyle noboldTextStyle = TextStyle(
  fontSize: 21,
  color: Color.fromRGBO(21, 21, 21, 1),
  fontWeight: FontWeight.w700,
);
TextStyle bigTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: MediaQuery.of(context).size.width / 10,
    color: Color.fromRGBO(50, 50, 50, 1),
    fontWeight: FontWeight.w400,
  );
}

TextStyle thinSmallTextStyle = TextStyle(
  fontSize: 10,
  color: Color.fromRGBO(21, 21, 21, 1),
  fontWeight: FontWeight.w500,
);
TextStyle thinTextStyle = TextStyle(
  fontSize: 22,
  color: Color.fromRGBO(244, 244, 244, 1),
  fontWeight: FontWeight.w500,
);

TextStyle whiteTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: MediaQuery.of(context).size.width / 18,
    color: Color.fromRGBO(255, 255, 255, 1),
    fontWeight: FontWeight.w500,
  );
}

TextStyle btnTextStyle = TextStyle(
  fontSize: 20,
  color: Color.fromRGBO(255, 255, 255, 1),
  fontWeight: FontWeight.w700,
);

// 로그인 글꼴 스타일

//login_input: 입력창 글꼴
// login_ok: 확인 버튼

TextStyle login_input(BuildContext context) {
  return TextStyle(
      height: 3,
      fontFamily: 'pretend',
      fontWeight: FontWeight.w500,
      color: Color.fromRGBO(4, 110, 184, 0.5),
      fontSize: 15);
}

TextStyle login_ok(BuildContext context) {
  return TextStyle(
      fontSize: MediaQuery.of(context).size.height / 30,
      fontWeight: FontWeight.w600,
      fontFamily: 'pretend',
      color: Colors.white);
}

//하단 회사 마크랑 인포있는거
//optilo_name : 옵티로 이름 있는부분
//optilo_info : 정보 있는부분

TextStyle optilo_name(BuildContext context) {
  return TextStyle(
    fontFamily: 'pretend',
    fontSize: MediaQuery.of(context).size.height / 60,
    color: Color.fromRGBO(50, 50, 50, 1),
    fontWeight: FontWeight.w600,
  );
}

TextStyle optilo_info(BuildContext context) {
  return TextStyle(
    fontFamily: 'pretend',
    fontSize: MediaQuery.of(context).size.height / 70,
    color: Color.fromRGBO(50, 50, 50, 1),
    fontWeight: FontWeight.w400,
  );
}

//메인 박스 쉐도우 스타일

BoxShadow mainbox() {
  return BoxShadow(
    color: Color.fromRGBO(189, 189, 189, 0.6),
    blurRadius: 3.0,
    spreadRadius: 3.0,
  );
}

BoxShadow customeBoxShadow() {
  return BoxShadow(
    color: Color.fromRGBO(189, 189, 189, 0.6),
    blurRadius: 3.0,
    spreadRadius: 3.0,
  );
}

// 메인페이지 글꼴 스타일

//M_Name : Mac Adress 번호
// End:종료버튼
// Locate:배송지
//UpLoad:업로드시간
//Temp:온도, 배터리양

TextStyle Locate(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(0, 54, 92, 1),
    fontSize: MediaQuery.of(context).size.width / 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'pretend',
  );
}

TextStyle End(BuildContext context) {
  return TextStyle(
      fontSize: MediaQuery.of(context).size.width / 25,
      fontWeight: FontWeight.w600,
      fontFamily: 'pretend',
      color: Color.fromRGBO(90, 90, 90, 1));
}

TextStyle M_Name(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(51, 51, 51, 1),
    fontSize: MediaQuery.of(context).size.width / 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'pretend',
  );
}

TextStyle UpLoad(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(51, 51, 51, 1),
    fontSize: MediaQuery.of(context).size.width / 27,
    fontWeight: FontWeight.w500,
    fontFamily: 'pretend',
  );
}

TextStyle Sidebar(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(75, 75, 75, 1.0),
    fontSize: MediaQuery.of(context).size.width / 25,
    fontWeight: FontWeight.w700,
    fontFamily: 'pretend',
  );
}

TextStyle Temp(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(51, 51, 51, 1),
    fontSize: MediaQuery.of(context).size.width / 25,
    fontWeight: FontWeight.w700,
    fontFamily: 'pretend',
  );
}

// 메인페이지 종료 버튼 누르면 나오는 팝업 화면 글꼴 스타일

//pop_title : 배송지별 운송완료 글꼴 스타일
//pop_name : 박스 이름
//pop_complete : 운송완료 버튼
//pop_locate : 운송지
//pop_end : 나가기 버튼

TextStyle pop_title(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(5, 111, 186, 1),
    fontFamily: 'pretend',
    fontSize: MediaQuery.of(context).size.height / 40,
    fontWeight: FontWeight.w600,
  );
}

TextStyle pop_name(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(62, 62, 62, 1.0),
    fontFamily: 'pretend',
    fontSize: MediaQuery.of(context).size.width / 15,
    fontWeight: FontWeight.w700,
  );
}

TextStyle pop_complete(BuildContext context) {
  return TextStyle(
      color: Color.fromRGBO(2, 66, 110, 1.0),
      fontFamily: 'pretend',
      fontSize: MediaQuery.of(context).size.width / 28,
      fontWeight: FontWeight.w700);
}

TextStyle pop_locate(BuildContext context) {
  return TextStyle(
      color: Color.fromRGBO(0, 54, 92, 1.0),
      fontFamily: 'pretend',
      fontSize: MediaQuery.of(context).size.width / 20,
      fontWeight: FontWeight.w600);
}

TextStyle pop_end(BuildContext context) {
  return TextStyle(
      color: Color.fromRGBO(255, 255, 255, 1.0),
      fontFamily: 'pretend',
      fontSize: MediaQuery.of(context).size.width / 30,
      fontWeight: FontWeight.w700);
}

//제대혈 페이지 글꼴 스타일

//cord_name : 박스 이름
//cord_temp : 온도, 배터리양
//cord_upload : 업로드시간
//cord_input : 입력 버튼

TextStyle cord_name(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(21, 96, 53, 1),
    fontSize: MediaQuery.of(context).size.height / 30,
    fontWeight: FontWeight.w700,
    fontFamily: 'pretend',
  );
}

TextStyle cord_temp(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(51, 51, 51, 1),
    fontSize: MediaQuery.of(context).size.width / 28,
    fontWeight: FontWeight.w700,
    fontFamily: 'pretend',
  );
}

TextStyle cord_upload(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(51, 51, 51, 1),
    fontSize: MediaQuery.of(context).size.width / 32,
    fontWeight: FontWeight.w700,
    fontFamily: 'pretend',
  );
}

TextStyle cord_input(BuildContext context) {
  return TextStyle(
      fontSize: MediaQuery.of(context).size.width / 30,
      fontWeight: FontWeight.w700,
      fontFamily: 'pretend',
      color: Color.fromRGBO(255, 255, 255, 1.0));
}

//제대혈 팝업 페이지 글꼴 스타일

//cordpop_info : 현재박스 정보 글꼴 스타일
//cordpop_name : 기기이름,도착지, 현재온도 글꼴 스타일
//cordpop_input : 기기이름,도착지, 현재온도 입력창 글꼴 스타일
//cordpop_upload : 업로드시간
//cordpop_complete : 완료 버튼

TextStyle cordpop_info(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(21, 96, 53, 1),
    fontSize: MediaQuery.of(context).size.height / 28,
    fontWeight: FontWeight.w800,
    fontFamily: 'pretend',
  );
}

TextStyle cordpop_name(BuildContext context) {
  return TextStyle(
      fontSize: MediaQuery.of(context).size.width / 20,
      fontWeight: FontWeight.w700,
      fontFamily: 'pretend',
      color: Color.fromRGBO(51, 51, 51, 1.0));
}

TextStyle cordpop_input(BuildContext context) {
  return TextStyle(
    height: 3,
    fontFamily: 'pretend',
    fontWeight: FontWeight.w500,
    color: Color.fromRGBO(21, 96, 53, 0.5),
    fontSize: MediaQuery.of(context).size.height / 50,
  );
}

TextStyle cordpop_upload(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(51, 51, 51, 1),
    fontSize: MediaQuery.of(context).size.height / 50,
    fontWeight: FontWeight.w600,
    fontFamily: 'pretend',
  );
}

TextStyle cordpop_complete(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(255, 255, 255, 1.0),
    fontFamily: 'pretend',
    fontSize: MediaQuery.of(context).size.width / 20,
    fontWeight: FontWeight.w700,
  );
}

//앱과 기기 사이에 데이터 전송 상태에 따른 색상
//state_sending_orage:데이터전송중
//state_complete_green: 데이터 전송완료
//state_ing_red: 연결중
//state_waiting_gray:대기중

TextStyle state_searching_blue(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(103, 153, 255, 1),
    fontSize: MediaQuery.of(context).size.width / 23,
    fontWeight: FontWeight.w800,
    fontFamily: 'pretend',
  );
}

TextStyle state_sending_orage(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(249, 142, 43, 1),
    fontSize: MediaQuery.of(context).size.width / 23,
    fontWeight: FontWeight.w800,
    fontFamily: 'pretend',
  );
}

TextStyle state_complete_green(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(30, 135, 74, 1),
    fontSize: MediaQuery.of(context).size.width / 23,
    fontWeight: FontWeight.w800,
    fontFamily: 'pretend',
  );
}

TextStyle state_ing_red(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(227, 40, 53, 1),
    fontSize: MediaQuery.of(context).size.width / 23,
    fontWeight: FontWeight.w800,
    fontFamily: 'pretend',
  );
}

TextStyle state_waiting_gray(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(102, 102, 102, 1),
    fontSize: MediaQuery.of(context).size.width / 23,
    fontWeight: FontWeight.w800,
    fontFamily: 'pretend',
  );
}

TextStyle state_end_gray(BuildContext context) {
  return TextStyle(
    color: Color.fromRGBO(50, 50, 50, 1),
    fontSize: MediaQuery.of(context).size.width / 23,
    fontWeight: FontWeight.w800,
    fontFamily: 'pretend',
  );
}

Widget getbatteryImage(BuildContext context, int battery) {
  if (battery >= 75) {
    return Image(
      image: AssetImage('assets/images/battery_100.png'),
      fit: BoxFit.contain,
      width: MediaQuery.of(context).size.width * 0.08,
      height: MediaQuery.of(context).size.width * 0.08,
    );
  } else if (battery >= 50) {
    return Image(
      image: AssetImage('assets/images/battery_75.png'),
      fit: BoxFit.contain,
      width: MediaQuery.of(context).size.width * 0.08,
      height: MediaQuery.of(context).size.width * 0.08,
    );
  } else if (battery >= 35) {
    return Image(
      image: AssetImage('assets/images/battery_50.png'),
      fit: BoxFit.contain,
      width: MediaQuery.of(context).size.width * 0.08,
      height: MediaQuery.of(context).size.width * 0.08,
    );
  } else if (battery >= 0) {
    return Image(
      image: AssetImage('assets/images/battery_25.png'),
      fit: BoxFit.contain,
      width: MediaQuery.of(context).size.width * 0.08,
      height: MediaQuery.of(context).size.width * 0.08,
    );
  } else {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

TextStyle stateStyle(BuildContext context, String input) {
  if (input == '온도센서 스캔 중') {
    return state_searching_blue(context);
  } else if (input == '온도센서 연결 완료') {
    return state_complete_green(context);
  } else if (input == '데이터 전송 실패') {
    return state_ing_red(context);
  } else {
    return state_end_gray(context);
  }
}
