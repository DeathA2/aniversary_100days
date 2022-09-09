import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aniversary_100days/end_screen/end_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class EndAnniversaryScreen extends StatefulWidget {
  const EndAnniversaryScreen({Key? key}) : super(key: key);

  @override
  State<EndAnniversaryScreen> createState() => _EndAnniversaryScreenState();
}

class _EndAnniversaryScreenState extends State<EndAnniversaryScreen> {
  var _image = "assets/images/fstmeet/IMG1.jpg";
  var count = 1;
  final player = AudioPlayer();

  void playSoundEffect() async{
    player.setReleaseMode(ReleaseMode.loop);

    final players = AudioCache(prefix: '');
    final url = await players.load('assets/audio/sound_effect/happy-sound-effect.mp3');
    await player.setSourceUrl(url.path);
    await player.resume();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  void getPictureEndAnniversary() {
    if (count <= 10) {
      Timer(const Duration(milliseconds: 400), () {
        setState(() {
          if (count == 10) {
            _image = "assets/images/fstmeet/IMG$count.gif";
          } else {
            _image = "assets/images/fstmeet/IMG$count.jpg";
          }
          count++;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    playSoundEffect();
    getPictureEndAnniversary();
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        constraints: const BoxConstraints.expand(),
        color: Colors.black,
        child: Stack(
          children: [
            FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 2000)),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox();
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    constraints: const BoxConstraints.expand(),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://media4.giphy.com/media/vaKIZHbPN3vb2/giphy.gif"),
                            fit: BoxFit.cover)),
                  );
                })),
            Center(
                child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Container(
                key: UniqueKey(),
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(_image),
                  fit: BoxFit.cover,
                )),
              ),
            )),
            FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 2000)),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox();
                  }
                  return Positioned(
                      top: 20,
                      left: MediaQuery.of(context).size.width / 2 - 175,
                      child: SizedBox(
                        width: 350.0,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'Press',
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText('Happy Anniversary',
                                  speed: const Duration(milliseconds: 100),
                                  textAlign: TextAlign.center),
                            ],
                            totalRepeatCount: 10,
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      child: EndScreen(),
                                      type: PageTransitionType.scale,
                                      alignment: Alignment.bottomCenter));
                            },
                            onFinished: () {
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      child: EndScreen(),
                                      type: PageTransitionType.scale,
                                      alignment: Alignment.bottomCenter));
                            },
                          ),
                        ),
                      ));
                })),
            FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 2000)),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox();
                  }
                  return Positioned(
                      bottom: 30,
                      left: MediaQuery.of(context).size.width / 2 - 175,
                      child: SizedBox(
                        width: 350.0,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 40.0,
                            fontFamily: 'Press',
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              WavyAnimatedText('100 DAYS',
                                  speed: const Duration(milliseconds: 200),
                                  textAlign: TextAlign.center),
                            ],
                            stopPauseOnTap: true,
                            pause: const Duration(seconds: 1),
                            onFinished: () {},
                          ),
                        ),
                      ));
                }))
          ],
        ));
  }
}
