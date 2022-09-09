import 'package:aniversary_100days/login_next_time/screen/conversation_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MainNextOtherScreen extends StatefulWidget {
  const MainNextOtherScreen({Key? key}) : super(key: key);

  @override
  _MainNextOtherScreenState createState() => _MainNextOtherScreenState();
}

class _MainNextOtherScreenState extends State<MainNextOtherScreen> {

  final player = AudioPlayer();

  void playSoundEffect() async{
    player.setReleaseMode(ReleaseMode.loop);

    final players = AudioCache(prefix: '');
    final url = await players.load('assets/audio/sound_effect/happy-moments-sound-effects.mp3');
    await player.setSourceUrl(url.path);
    await player.resume();
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
                  const MainNextScreen(),
                ],
              );
            }));
  }
}
