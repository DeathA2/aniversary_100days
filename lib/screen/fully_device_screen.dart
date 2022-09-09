import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class FullyDeviceScreen extends StatefulWidget {
  const FullyDeviceScreen({Key? key}) : super(key: key);

  @override
  _FullyDeviceScreenState createState() => _FullyDeviceScreenState();
}

class _FullyDeviceScreenState extends State<FullyDeviceScreen> {
  int selectColor = 0;

  final player = AudioPlayer();

  void playSoundEffect() async{
    player.setReleaseMode(ReleaseMode.loop);

    final players = AudioCache(prefix: '');
    final url = await players.load('assets/audio/sound_effect/error-retsudozon.mp3');
    await player.setSourceUrl(url.path);
    await player.resume();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  List<Color> gradientColors = [
    Colors.white,
    Colors.white,
    Colors.yellow,
    Colors.yellow,
    Colors.lightBlue,
    Colors.lightBlue,
    Colors.redAccent,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.purpleAccent
  ];
  @override
  Widget build(BuildContext context) {
    playSoundEffect();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.png"),
            fit: BoxFit.fitHeight,
          )),
      child: Stack(
        children: [
          Positioned(
              bottom: 10,
              left: MediaQuery.of(context).size.width / 2 - 150,
              child: SizedBox(
                width: 300,
                height: 500,
                child: Stack(
                  children: [
                    Positioned(
                        child: Image.asset("assets/character/no_internet.png")),
                    Positioned(
                        right: 17,
                        bottom: 280,
                        child: Container(
                            width: 173,
                            height: 110,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                  inherit: false,
                                  fontFamily: "Press",
                                  fontSize: 17),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                      "Sorry! You can't run this app!",
                                      textAlign: TextAlign.center,
                                      speed: const Duration(milliseconds: 100),
                                      textStyle: TextStyle(
                                          color: gradientColors[selectColor])),
                                  TypewriterAnimatedText(
                                      "The number of accessible devices is full!",
                                      textAlign: TextAlign.center,
                                      speed: const Duration(milliseconds: 100),
                                      textStyle: TextStyle(
                                          color: gradientColors[selectColor])),
                                ],
                                repeatForever: true,
                                pause: const Duration(milliseconds: 500),
                                onNextBeforePause: (i,boolean){
                                  setState(() {
                                    if (selectColor == gradientColors.length-1){
                                      selectColor = 0;
                                      return ;
                                    }
                                    selectColor++;
                                  });
                                },
                              ),
                            ))),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
