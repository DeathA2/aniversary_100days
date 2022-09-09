import 'dart:convert';

import 'package:aniversary_100days/second_meet/conversation_second.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainScreenSecond extends StatefulWidget {
  const MainScreenSecond({Key? key}) : super(key: key);

  @override
  _MainScreenSecondState createState() => _MainScreenSecondState();
}

class _MainScreenSecondState extends State<MainScreenSecond> {

  String url = 'https://my-json-server.typicode.com/DeathA2/meetbeast/db';
  List secondMeet = [];

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
    secondMeet = data['second'];
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
    _getJsondata();
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bgmeet.png'),
                fit: BoxFit.cover)),
        child: FutureBuilder(
            future: Future.delayed(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return SizedBox();
              }
              return Stack(
                children: [
                  Positioned(
                    bottom: 120,
                    left: 20,
                    child: Container(
                      width: 100,
                      height: 200,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/character/beast.png"),
                        fit: BoxFit.contain,
                      )),
                    ),
                  ),
                  Positioned(
                      bottom: 120,
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
                  SecondConversation(
                    conversation: secondMeet,
                    endMeet: (){},
                    changeBg: (){},
                    changePic: (){},
                  ),
                ],
              );
            }));
  }
}
