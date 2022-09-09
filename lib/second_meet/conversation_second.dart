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

class SecondConversation extends StatefulWidget {
  final List? conversation;
  final EndMeet endMeet;
  final ChangeBG changeBg;
  final ChangePic changePic;
  const SecondConversation(
      {Key? key,
      this.conversation,
      required this.endMeet,
      required this.changeBg,
      required this.changePic})
      : super(key: key);

  @override
  _SecondConversationState createState() => _SecondConversationState();
}

class _SecondConversationState extends State<SecondConversation> {
  bool _check = false;
  final db = FirebaseDatabase.instance.ref();
  String princessName = '';
  String crushName = '';
  Random random = Random();

  void getPrincessName() async {
    var _princessName = await FirebaseDatabase.instance
        .ref("/id/${User.idPhone}")
        .child("princess")
        .get();
    var _crushName = await FirebaseDatabase.instance
        .ref("/id/${User.idPhone}")
        .child("crush")
        .get();
    var __princessName = '';
    setState(() {
      if (_princessName.exists) {
        __princessName = _princessName.value.toString();
      }
      if (_crushName.exists) {
        crushName = _crushName.value.toString();
      }
    });
    List listPrincessName = [
      "Cô gái nhỏ",
      __princessName,
      "Công chúa",
      "Cô gái thích $crushName"
    ];
    princessName = listPrincessName[random.nextInt(4)];
  }

  List<TyperAnimatedText> secondConversationContent(int cnt, Map data) {
    List<TyperAnimatedText> list = [];
    for (int i = 0; i <= cnt; i++) {
      list.add(buildConverstation(data));
    }
    return list;
  }

  void updateBubble(int i, bool bl) {
    bool beast = false;
    bool princess = false;
    if (widget.conversation?[SecondMeet.countList]['name'] == 'Beast') {
      beast = true;
      princess = false;
    }
    if (widget.conversation?[SecondMeet.countList]['name'] == 'Princess') {
      beast = false;
      princess = true;
    }

    setState(() {
      SecondMeet.beast = beast;
      SecondMeet.princess = princess;
    });
  }

  void update(int i, bool bl) {
    if (SecondMeet.countList == 5) return;
    setState(() {
      ++SecondMeet.countList;
      ++SecondMeet.count;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getPrincessName();
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
                          child: (!_check)
                              ? AnimatedTextKit(
                                  animatedTexts: secondConversationContent(
                                      SecondMeet.count,
                                      widget
                                          .conversation?[SecondMeet.countList]),
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
                                  onNextBeforePause: update,
                                  onNext: (SecondMeet.countList == 5)
                                      ? null
                                      : updateBubble,
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                        child: TextButton(
                                      style: ButtonStyle(
                                          side: MaterialStateProperty.all(
                                              const BorderSide(
                                                  width: 1,
                                                  color: Colors.white)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green)),
                                      onPressed: () {
                                        db
                                            .child("/id/${User.idPhone}")
                                            .update({"happy": "Rất hạnh phúc"});
                                        setState(() {
                                          SecondMeet.count = 0;
                                          SecondMeet.countList++;
                                          _check = false;
                                          SecondMeet.beast = true;
                                          SecondMeet.princess = false;
                                        });
                                      },
                                      child: const Text("Rất hạnh phúc",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "Saira",
                                              color: Colors.black,
                                              fontSize: 18)),
                                    )),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                        child: TextButton(
                                      style: ButtonStyle(
                                          side: MaterialStateProperty.all(
                                              const BorderSide(
                                                  width: 1,
                                                  color: Colors.white)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.blue)),
                                      onPressed: () {
                                        db.child("/id/${User.idPhone}").update(
                                            {"happy": "Cũng có hạnh phúc"});
                                        // setState(() {
                                        //   SecondMeet.count = 0;
                                        //   SecondMeet.countList++;
                                        //   _check = false;
                                        //   SecondMeet.beast = true;
                                        //   SecondMeet.princess = false;
                                        // });
                                      },
                                      child: const Text(
                                        "Cũng có hạnh phúc",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Saira",
                                            color: Colors.black,
                                            fontSize: 18),
                                      ),
                                    )),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                        child: TextButton(
                                      style: ButtonStyle(
                                          side: MaterialStateProperty.all(
                                              const BorderSide(
                                                  width: 1,
                                                  color: Colors.white)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red)),
                                      onPressed: () {
                                        db.child("/id/${User.idPhone}").update(
                                            {"happy": "Hông hạnh phúc"});
                                        // setState(() {
                                        //   SecondMeet.count = 0;
                                        //   SecondMeet.countList++;
                                        //   _check = false;
                                        //   SecondMeet.beast = true;
                                        //   SecondMeet.princess = false;
                                        // });
                                      },
                                      child: const Text("Hông hạnh phúc",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "Saira",
                                              color: Colors.black,
                                              fontSize: 18)),
                                    ))
                                  ],
                                )))
                ],
              ),
            )),
        Positioned(
            bottom: 300,
            right: 50,
            child: Visibility(
              visible: SecondMeet.princess,
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
              visible: SecondMeet.beast,
              child: SizedBox(
                width: 140,
                height: 100,
                child: Image.asset('assets/icons/left_bubble.gif'),
              ),
            ))
      ],
    );
  }

  TyperAnimatedText buildConverstation(Map i) {
    switch (i['id']) {
      case 2:
        return TyperAnimatedText(
            "${i['name']} : ${i['content']} $princessName.");
      case 4:
        _check = true;
        return TyperAnimatedText("${i['name']} : ${i['content']}");
      default:
        return TyperAnimatedText("${i['name']} : ${i['content']}");
    }
  }
}
