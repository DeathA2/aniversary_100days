import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aniversary_100days/data.dart';
import 'package:aniversary_100days/second_meet/mainscreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

typedef EndMeet = Function();
typedef ChangeBG = Function();
typedef ChangePic = Function();

class UpdateBubbleChat extends StatefulWidget {
  final List? conversation;
  final EndMeet endMeet;
  final ChangeBG changeBg;
  final ChangePic changePic;
  const UpdateBubbleChat(
      {Key? key,
      this.conversation,
      required this.endMeet,
      required this.changeBg,
      required this.changePic})
      : super(key: key);

  @override
  _UpdateBubbleChatState createState() => _UpdateBubbleChatState();
}

class _UpdateBubbleChatState extends State<UpdateBubbleChat> {
  bool _name = false;
  bool _crush = false;
  final db = FirebaseDatabase.instance.ref();
  final TextEditingController _textName = TextEditingController();
  final TextEditingController _textCrush = TextEditingController();
  String princessName = '';
  String crushName = '';

  List<TyperAnimatedText> firstConversation(int cnt, Map data) {
    List<TyperAnimatedText> list = [];
    for (int i = 0; i <= cnt; i++) {
      list.add(buildConverstation(data));
    }
    return list;
  }

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
      "Cô gái thích ${crushName}"
    ];
    princessName = listPrincessName[1];
  }

  void updateBubble(int i, bool bl) {
    bool beast = false;
    bool princess = false;
    if (widget.conversation?[FirstMeet.countList]['name'] == 'Beast') {
      beast = true;
      princess = false;
    }
    if (widget.conversation?[FirstMeet.countList]['name'] == 'Princess') {
      beast = false;
      princess = true;
    }
    if (widget.conversation?[FirstMeet.countList]['id'] == 20) {
      widget.endMeet();
    }

    setState(() {
      FirstMeet.beast = beast;
      FirstMeet.princess = princess;
    });
  }

  void update(int i, bool bl) {
    if (widget.conversation?[FirstMeet.countList]['id'] == 20) {
      widget.changeBg();
    }
    if (FirstMeet.countList == 20) return;
    setState(() {
      ++FirstMeet.countList;
      ++FirstMeet.count;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (FirstMeet.countList > 10 || FirstMeet.countList < 15) {
      getPrincessName();
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
                    child: (!_name)
                        ? AnimatedTextKit(
                            animatedTexts: firstConversation(FirstMeet.count,
                                widget.conversation?[FirstMeet.countList]),
                            totalRepeatCount: 1,
                            isRepeatingAnimation: false,
                            pause: const Duration(milliseconds: 1000),
                            displayFullTextOnTap: true,
                            stopPauseOnTap: true,
                            onFinished: () {
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      child: SecondMeetScreen(),
                                      type: PageTransitionType.fade));
                            },
                            onNextBeforePause: update,
                            onNext: (FirstMeet.countList == 20)
                                ? null
                                : updateBubble,
                          )
                        : (!_crush)
                            ? TextFormField(
                                controller: _textName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Saira',
                                ),
                                decoration: InputDecoration(
                                  hintText: "Nhập tên của công chúa",
                                  hintStyle: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white70),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                onEditingComplete: () {
                                  if (_textName.text.isNotEmpty) {
                                    db
                                        .child("/id/${User.idPhone}/")
                                        .child("princess")
                                        .set(_textName.text);
                                  }
                                  // print(_textName);
                                  setState(() {
                                    // widget.changePic();
                                    FirstMeet.count = 0;
                                    FirstMeet.countList++;
                                    _name = false;
                                    FirstMeet.beast = true;
                                    FirstMeet.princess = false;
                                  });
                                },
                              )
                            : TextFormField(
                                controller: _textCrush,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Saira',
                                ),
                                decoration: InputDecoration(
                                  hintText: "Nhập người công chúa thích",
                                  hintStyle: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white70),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                onEditingComplete: () {
                                  if (_textCrush.text.isNotEmpty) {
                                    db
                                        .child("/id/${User.idPhone}/")
                                        .child("crush")
                                        .set(_textCrush.text);
                                  }
                                  // print(_textName);
                                  setState(() {
                                    // widget.changePic();

                                    FirstMeet.count = 0;
                                    FirstMeet.countList++;
                                    _name = false;

                                    FirstMeet.beast = true;
                                    FirstMeet.princess = false;
                                  });
                                },
                              ),
                  ))
                ],
              ),
            )),
        Positioned(
            bottom: 320,
            right: 50,
            child: Visibility(
              visible: FirstMeet.princess,
              child: SizedBox(
                width: 140,
                height: 100,
                child: Image.asset('assets/icons/bubble_right.gif'),
              ),
            )),
        Positioned(
            bottom: 320,
            left: 50,
            child: Visibility(
              visible: FirstMeet.beast,
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
      case 1:
        // _beast = true;
        return TyperAnimatedText("${i['name']} : ${i['content']}",
            textStyle: const TextStyle(fontWeight: FontWeight.bold));
      // break;
      // case 2:
      //   return TyperAnimatedText()
      //   break;
      // case 3:
      //   return TyperAnimatedText()
      //   break;
      case 4:
        return TyperAnimatedText(i['content'],
            textStyle: const TextStyle(fontStyle: FontStyle.italic));
      case 6:
        _name = true;
        return TyperAnimatedText("${i['name']} : ${i['content']}",
            textStyle: const TextStyle(fontWeight: FontWeight.bold));
      case 12:
        return TyperAnimatedText("${i['name']} : $princessName ${i['content']}",
            textStyle: const TextStyle(fontWeight: FontWeight.bold));
      case 18:
        _name = true;
        _crush = true;
        return TyperAnimatedText("${i['name']} : ${i['content']}",
            textStyle: const TextStyle(fontWeight: FontWeight.bold));
      case 20:
        return TyperAnimatedText(i['content'],
            textStyle: const TextStyle(fontStyle: FontStyle.italic));
      default:
        return TyperAnimatedText("${i['name']} : ${i['content']}");
    }
  }
}
