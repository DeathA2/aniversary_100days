import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aniversary_100days/data.dart';
import 'package:aniversary_100days/second_meet/main/screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

typedef EndMeet = Function();
typedef ChangeBG = Function();
typedef ChangePic = Function();

class MainNextScreen extends StatefulWidget {
  const MainNextScreen(
      {Key? key,})
      : super(key: key);

  @override
  _MainNextScreenState createState() => _MainNextScreenState();
}

class _MainNextScreenState extends State<MainNextScreen> {
  final db = FirebaseDatabase.instance.ref();
  String princessName = '';
  String crushName = '';
  Random random = Random();

  Future<void> getPrincessName() async {
    var _princessName = await FirebaseDatabase.instance
        .ref("/id/${User.idPhone}")
        .child("princess")
        .get();
    var _crushName = await FirebaseDatabase.instance
        .ref("/id/${User.idPhone}")
        .child("crush")
        .get();
    var __princessName = '';
      if (_princessName.exists) {
        __princessName = _princessName.value.toString();
      }
      if (_crushName.exists) {
        crushName = _crushName.value.toString();
      }
    List listPrincessName = [
      "Cô gái nhỏ",
      __princessName,
      "Công chúa",
      "Cô gái thích $crushName"
    ];
    princessName = listPrincessName[random.nextInt(4)];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: getPrincessName(),
        builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done){
        return SizedBox();
      }
      return Stack(
        children: [
          Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 160,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                        child: DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Saira',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            child: AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText("Beast : Rất vui lại được gặp cô, $princessName. "),
                                  TyperAnimatedText("Beast : Lại gần đây nào cô gái!"),
                                ],
                                totalRepeatCount: 1,
                                isRepeatingAnimation: false,
                                pause: const Duration(milliseconds: 1000),
                                displayFullTextOnTap: true,
                                stopPauseOnTap: true,
                                onFinished: () {
                                  Navigator.of(context).pushReplacement(
                                      PageTransition(
                                          child: MainScreenAnniversary(),
                                          type: PageTransitionType.fade));
                                },
                                onNextBeforePause: null,
                                onNext: null
                            )))
                  ],
                ),
              )),
          Positioned(
              bottom: 300,
              right: 50,
              child: Visibility(
                visible: false,
                child: SizedBox(
                  width: 140,
                  height: 100,
                  child: Image.asset('assets/icons/bubble_right.gif'),
                ),
              )),
          Positioned(
              bottom: 300,
              left: 50,
              child: Visibility(
                visible: true,
                child: SizedBox(
                  width: 140,
                  height: 100,
                  child: Image.asset('assets/icons/left_bubble.gif'),
                ),
              ))
        ],
      );
    });
  }
}
