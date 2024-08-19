import 'package:flutter/material.dart';
import 'package:geo_j/constants/style.dart';
import 'package:geo_j/models/signin_info.dart';

shipFinishDialog(BuildContext context, A10 a10) {
  return showDialog(
    // barrierDismissible: false,
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Color.fromRGBO(253, 253, 253, 1.0),
        elevation: 16.0,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.4,
          padding: EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.7,
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      '배송지별 운송완료',
                      style: pop_title(context),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ),
                // ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text('${a10.deNumber} ${a10.boxName}',
                        style: pop_name(context),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () async {
                            Navigator.of(context).pop(1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(2, 66, 110, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60))),
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height / 13,
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(bottom: 4),
                            alignment: Alignment.center,
                            child: Text(
                              // 색상 변환 -> 회 완료
                              '운송완료',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width / 16,
                                color: Color.fromRGBO(244, 244, 244, 1),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {
                                Navigator.of(context).pop(2);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(200, 52, 12, 0),
                                ),
                                height: MediaQuery.of(context).size.height / 15,
                                width: MediaQuery.of(context).size.width * 0.35,
                                padding: EdgeInsets.all(8),
                                alignment: Alignment.center,
                                child: Text(
                                  '회송',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 20,
                                    color: Color.fromRGBO(200, 52, 12, 1),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                Navigator.of(context).pop(0);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(244, 244, 244, 0)),
                                height: MediaQuery.of(context).size.height / 15,
                                width: MediaQuery.of(context).size.width * 0.35,
                                padding: EdgeInsets.all(8),
                                alignment: Alignment.center,
                                child: Text(
                                  '재배송',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 20,
                                    color: Color.fromRGBO(37, 93, 4, 1),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}
