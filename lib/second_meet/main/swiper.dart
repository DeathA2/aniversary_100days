import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:aniversary_100days/second_meet/main/swiper/end_anniversary_screen.dart';
import 'package:aniversary_100days/swiper/swipe_4_direction.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart' hide DismissDirection;
import 'package:flutter/material.dart' hide DismissDirection;
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:aniversary_100days/data.dart';

class UpdateSwiper extends StatefulWidget {
  const UpdateSwiper({Key? key}) : super(key: key);

  @override
  _UpdateSwiperState createState() => _UpdateSwiperState();
}

class _UpdateSwiperState extends State<UpdateSwiper> {
  String _myimage = '';
  late List img = [];
  List randomNumber = [];
  Random random = Random();
  String date = '';
  int day = 0;
  bool _anni = false;
  final db = FirebaseDatabase.instance.ref();
  bool _endSwiper = false;


  Future _getJsondata() async {
    final res = await http.get(
        Uri.parse("https://my-json-server.typicode.com/DeathA2/images/db"));
    var data = jsonDecode(res.body);
    List day = data['day'];
    List month = data['month'];
    List year = data['year'];
    img = await [
      day[random.nextInt(day.length)],
      day[random.nextInt(day.length)],
      month[random.nextInt(month.length)],
      month[random.nextInt(month.length)],
      year[random.nextInt(year.length)],
      year[random.nextInt(year.length)],
      year[random.nextInt(year.length)],
      year[random.nextInt(year.length)],
    ];
    _myimage = img[date.length]['url'];
  }

  Future _getDataOtherDay() async {
    final res = await http.get(
        Uri.parse("https://my-json-server.typicode.com/DeathA2/images/db"));
    var data = jsonDecode(res.body);
    List anniver = data['anniversary'];
    List anniverUrl = [];
    for (var day in anniver){
      if (day['day'] == date){
        _myimage = day['url'];
        return;
      }
    }
    for (int i = 1; i<=8 ; i++){
      anniverUrl.add(anniver.last['url$i']);
    }
    _myimage = anniverUrl[random.nextInt(8)];
  }

  void increseVisit() async {
    var visit =
        await db.child("/id/${User.idPhone}").child("visit").get();
    var _visit;
    if (visit.exists) {
      _visit = visit.value;
    }
    db.child("/id/${User.idPhone}").child("visit").set(_visit + 1);
  }

  Future<void> checkAnni() async {
    var anni =
        await db.child("/id/${User.idPhone}").child("anniversary").get();
    if (anni.exists) {
      _anni = anni.value as bool;
    }
  }

  Future _getDate() async {
    checkAnni();
    if (_anni) {
      switch (date.length) {
        case 0:
          randomNumber = [
            random.nextInt(4),
            random.nextInt(4),
            random.nextInt(4),
            random.nextInt(4)
          ];
          break;
        case 1:
          if (date[0] == '3') {
            randomNumber = [
              random.nextInt(2),
              random.nextInt(2),
              random.nextInt(2),
              random.nextInt(2)
            ];
          } else {
            randomNumber = [
              random.nextInt(10),
              random.nextInt(10),
              random.nextInt(10),
              random.nextInt(10)
            ];
          }
          break;
        case 2:
          day = int.parse(date);
          randomNumber = [
            random.nextInt(2),
            random.nextInt(2),
            random.nextInt(2),
            random.nextInt(2)
          ];
          break;
        case 3:
          if (day > 28) {
            if (day == 31) {
              if (date[2] == '1') {
                List month = [0, 2];
                randomNumber = [
                  month[random.nextInt(month.length)],
                  month[random.nextInt(month.length)],
                  month[random.nextInt(month.length)],
                  month[random.nextInt(month.length)]
                ];
              } else {
                List month = [1, 3, 5, 7, 8];
                randomNumber = [
                  month[random.nextInt(month.length)],
                  month[random.nextInt(month.length)],
                  month[random.nextInt(month.length)],
                  month[random.nextInt(month.length)]
                ];
              }
            } else {
              if (date[2] == '0') {
                List month = [1, 3, 4, 5, 6, 7, 8, 9];
                randomNumber = [
                  month[random.nextInt(month.length)],
                  month[random.nextInt(month.length)],
                  month[random.nextInt(month.length)],
                  month[random.nextInt(month.length)]
                ];
              } else {
                randomNumber = [
                  random.nextInt(3),
                  random.nextInt(3),
                  random.nextInt(3),
                  random.nextInt(3)
                ];
              }
            }
          } else {
            if (date[2] == '1') {
              randomNumber = [
                random.nextInt(3),
                random.nextInt(3),
                random.nextInt(3),
                random.nextInt(3)
              ];
            } else {
              randomNumber = [
                random.nextInt(10),
                random.nextInt(10),
                random.nextInt(10),
                random.nextInt(10)
              ];
            }
          }

          break;
        case 4:
          randomNumber = [2, 2, 2, 2];
          break;
        case 5:
          randomNumber = [0, 0, 0, 0];
          break;
        case 6:
          randomNumber = [2, 2, 2, 2];
          break;
        case 7:
          randomNumber = [2, 1, 2, 1];
          break;
      }
    } else {
      switch (date.length) {
        case 0:
          randomNumber = [3, 3, 3, 3];
          break;
        case 1:
          randomNumber = [0, 0, 0, 0];
          break;
        case 2:
          randomNumber = [0, 0, 0, 0];
          break;
        case 3:
          randomNumber = [7, 7, 7, 7];
          break;
        case 4:
          randomNumber = [2, 2, 2, 2];
          break;
        case 5:
          randomNumber = [0, 0, 0, 0];
          break;
        case 6:
          randomNumber = [2, 2, 2, 2];
          break;
        case 7:
          randomNumber = [2, 2, 2, 2];
          break;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getJsondata();
    _getDate();
  }

  @override
  Widget build(BuildContext context) {
    return (!_endSwiper) ?  FutureBuilder(
      future: checkAnni(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox();
        }
        return FutureBuilder(
            future: _getDate(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox();
              }
              return Stack(
                fit: StackFit.loose,
                children: [
                  Positioned(
                      top: 0,
                      left: 150 - 25,
                      child: Text(
                        randomNumber[0].toString(),
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'Press',
                            inherit: false),
                      )),
                  Positioned(
                      bottom: 0,
                      left: 150 - 25,
                      child: Text(
                        randomNumber[2].toString(),
                        style: const TextStyle(
                            fontSize: 15, fontFamily: 'Press', inherit: false),
                      )),
                  Positioned(
                      top: 200 - 25,
                      left: 0,
                      child: Text(
                        randomNumber[1].toString(),
                        style: const TextStyle(
                            fontSize: 15, fontFamily: 'Press', inherit: false),
                      )),
                  Positioned(
                      top: 200 - 25,
                      right: 0,
                      child: Text(
                        randomNumber[3].toString(),
                        style: const TextStyle(
                            fontSize: 15, fontFamily: 'Press', inherit: false),
                      )),
                  Positioned(
                    top: 25,
                    left: 25,
                    child: MyDismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.all,
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.down) {
                          date = StringUtils.addCharAtPosition(
                              date, randomNumber[2].toString(), date.length);
                          if (date.length == 8) {
                            increseVisit();
                            if (date == "30072022") {
                              db
                                  .child(
                                  "/id/${User.idPhone}/anniversary")
                                  .set(true);
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      child: const EndAnniversaryScreen(),
                                      type: PageTransitionType.fade));
                            }
                            else {
                              setState(() {
                                _endSwiper = true;
                              });
                            }
                          }
                          _getDate();
                          setState(() {
                            _myimage = img[date.length]['url'];
                          });
                        }
                        if (direction == DismissDirection.up) {
                          date = StringUtils.addCharAtPosition(
                              date, randomNumber[0].toString(), date.length);

                          if (date.length == 8) {
                            increseVisit();
                            if (date == "30072022") {
                              db
                                  .child(
                                  "/id/${User.idPhone}/anniversary")
                                  .set(true);
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      child: const EndAnniversaryScreen(),
                                      type: PageTransitionType.fade));
                            }
                            else {
                              setState(() {
                                _endSwiper = true;
                              });
                            }
                            // Navigator.of(context).push(PageTransition(
                            //     child: Container(),
                            //     type: PageTransitionType.bottomToTop));
                          }
                          _getDate();
                          setState(() {
                            _myimage = img[date.length]['url'];
                          });
                        }
                        if (direction == DismissDirection.startToEnd) {
                          date = StringUtils.addCharAtPosition(
                              date, randomNumber[3].toString(), date.length);
                          if (date.length == 8) {
                            increseVisit();
                            if (date == "30072022") {
                              db
                                  .child(
                                  "/id/${User.idPhone}/anniversary")
                                  .set(true);
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      child: const EndAnniversaryScreen(),
                                      type: PageTransitionType.fade));
                            }
                            else {
                              setState(() {
                                _endSwiper = true;
                              });
                            }
                          }
                          _getDate();
                          setState(() {
                            _myimage = img[date.length]['url'];
                          });
                        }
                        if (direction == DismissDirection.endToStart) {
                          date = StringUtils.addCharAtPosition(
                              date, randomNumber[1].toString(), date.length);
                          if (date.length == 8) {
                            increseVisit();
                            if (date == "30072022") {
                              db
                                  .child(
                                  "/id/${User.idPhone}/anniversary")
                                  .set(true);
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      child: const EndAnniversaryScreen(),
                                      type: PageTransitionType.fade));
                            }
                            else {
                              setState(() {
                                _endSwiper = true;
                              });
                            }
                          }
                          _getDate();
                          setState(() {
                            _myimage = img[date.length]['url'];
                          });
                        }
                        return Future.value(true);
                      },
                      child: FutureBuilder(
                          future: _getJsondata(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const SizedBox(
                                  width: 250,
                                  height: 320,
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            }
                            return Container(
                              width: 250,
                              height: 320,
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(
                                    // "https://bom.so/hiVjXl"),
                                    // "https://lh3.googleusercontent.com/pw/AM-JKLVlNBiQhzLVw7iB43pReoeCqm35Jqo0BI_TlgPhGWH2ghvnsVokjH6tB44AubqwihRtsat_nzeNp1l1Sb3sy7GqBuL3ABwDnSQWghgeIY__9ot3J5Sm-uzRKunBE0lCe-Q5Hh8SbbFFO65wnqAwCgAC=w445-h903-k-no?authuser=0"),
                                      _myimage), fit: BoxFit.contain)),
                            );
                          }),
                    ),
                  ),
                ],
              );
            }));
      }),
    ) :
    FutureBuilder(
        future: _getDataOtherDay(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done){
            return SizedBox();
          }
          return MaterialButton(
              onPressed: (){
                setState(() {
                  _endSwiper = false;
                  date = '';
                   _getJsondata();
                });
              },
            child: Image.network(_myimage, fit: BoxFit.contain,),
          );
    }));
  }
}
