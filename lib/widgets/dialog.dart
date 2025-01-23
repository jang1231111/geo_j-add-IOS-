import 'package:flutter/material.dart';

startTimeDialog(BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('온도 수집 중입니다.'),
          content: Text('시작시간을 현재 시간으로 변경하시겠습니까 ?'),
          actions: <Widget>[
            TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.pop(context, true);
                }),
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      });
}
