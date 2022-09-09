import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class EndScreen extends StatefulWidget {
  const EndScreen({Key? key}) : super(key: key);

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  bool _end = false;

  final player = AudioPlayer();

  void playSoundEffect() async{
    player.setReleaseMode(ReleaseMode.loop);

    final players = AudioCache(prefix: '');
    final url = await players.load('assets/audio/sound_effect/edm-outro-dau-tien-nhac-edm-dang-cap.mp3');
    await player.setSourceUrl(url.path);
    await player.resume();
  }

  @override
  Widget build(BuildContext context) {
    playSoundEffect();
    Timer(Duration(seconds: 1), (){
      setState(() {
       _end = true;
      });
    });
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/artboard_1xhdpi.png"),
          fit: BoxFit.cover
        )
      ),
      child: Center(
        child: AnimatedContainer(
          width: _end ? MediaQuery.of(context).size.width * 0.8 : 0,
          height: _end ? MediaQuery.of(context).size.height: 0,
          alignment: Alignment.center,
          duration: Duration(seconds: 2),
          curve: Curves.linear,
          child: Image.asset("assets/images/document.png", fit: BoxFit.contain,),
        ),
      ),
    );
  }
}
