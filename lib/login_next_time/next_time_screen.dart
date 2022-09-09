import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aniversary_100days/login_next_time/screen/conversation_screen.dart';
import 'package:aniversary_100days/login_next_time/screen/nexttime_other_screen.dart';
import 'package:aniversary_100days/second_meet/second_meet.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class NextTimeScreen extends StatefulWidget {
  const NextTimeScreen({Key? key}) : super(key: key);

  @override
  _NextTimeScreenState createState() => _NextTimeScreenState();
}

class _NextTimeScreenState extends State<NextTimeScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: Center(
        child: DefaultTextStyle(
          style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              FadeAnimatedText('Một thời gian sau...',
                duration: const Duration(seconds: 3),
              ),
            ],
            pause: const Duration(milliseconds: 100),
            totalRepeatCount: 1,
            onFinished: () {
              Navigator.of(context).pushReplacement(PageTransition(
                  child: MainNextOtherScreen(), type: PageTransitionType.fade));
            },
          ),
        ),
      ),
      // child: Text(
      //   "Một thời gian sau...",
      //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      // ),
    );
  }
}
