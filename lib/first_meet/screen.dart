import 'dart:async';
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aniversary_100days/data.dart';
import 'package:aniversary_100days/first_meet/beast_character.dart';
import 'package:aniversary_100days/first_meet/bubble_update.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MeetScreen extends StatefulWidget {
  const MeetScreen({Key? key}) : super(key: key);

  @override
  _MeetScreenState createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> {
  final GlobalKey<BeastState> _mykey = GlobalKey();
  // final GlobalKey<ChangePictureState> _mykeys = GlobalKey();

  bool _endFirstMeet = false;
  // bool _enableChange = true;
  //HTTP REQUEST get data from fake API
  String url = 'https://my-json-server.typicode.com/DeathA2/meetbeast/db';
  List firstMeet = [];

  final player = AudioPlayer();

  void playSoundEffect() async{
    player.setReleaseMode(ReleaseMode.loop);

    final players = AudioCache(prefix: '');
    final url = await players.load('assets/audio/sound_effect/happy-moments-sound-effects.mp3');
    await player.setSourceUrl(url.path);
    await player.resume();
  }


  Future _getJsondata() async {
    final res = await http.get(Uri.parse(url));
    var data = jsonDecode(res.body);
    firstMeet = data['first'];
  }

  void endFstMeet() {
    _mykey.currentState?.endMeet();
  }

  void changeBG() {
    setState(() {
      FirstMeet.count = -1;
      _endFirstMeet = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getJsondata();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    playSoundEffect();
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: (_endFirstMeet)
            ? const AssetImage("assets/images/artboard_1xhdpi.png")
            : const AssetImage("assets/images/bgmeet.png"),
        fit: BoxFit.cover,
      )),
      constraints: const BoxConstraints.expand(),
      child: FutureBuilder(
          future: _getJsondata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox();
            }
            if (firstMeet.isEmpty) {
              return const SizedBox();
            }
            return Stack(
              children: [
                Positioned(
                    bottom: 170,
                    left: 20,
                    child: Beast(
                      key: _mykey,
                    )),
                Positioned(
                    bottom: 170,
                    right: 20,
                    child: Container(
                      width: 100,
                      height: 200,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/character/princess.png"),
                        fit: BoxFit.contain,
                      )),
                    )),
                UpdateBubbleChat(
                  conversation: firstMeet,
                  endMeet: endFstMeet,
                  changeBg: changeBG,
                  changePic: () {},
                ),
              ],
            );
          }),
    ));
  }
}
