import 'package:aniversary_100days/second_meet/main/music.dart';
import 'package:aniversary_100days/second_meet/main/swiper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart' hide DismissDirection;

class MainScreenAnniversary extends StatefulWidget {
  const MainScreenAnniversary({Key? key}) : super(key: key);

  @override
  _MainScreenAnniversaryState createState() => _MainScreenAnniversaryState();
}

class _MainScreenAnniversaryState extends State<MainScreenAnniversary> {
  final player = AudioPlayer();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/bgmeet.png"),
        fit: BoxFit.cover,
      )),
      child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox();
            }
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  bottom: 140,
                  left: 20,
                  child: Container(
                    width: 80,
                    height: 150,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/character/beast.png"),
                      fit: BoxFit.contain,
                    )),
                  ),
                ),
                Positioned(
                    bottom: 140,
                    right: 20,
                    child: Container(
                      width: 80,
                      height: 150,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/character/princess.png"),
                        fit: BoxFit.contain,
                      )),
                    )),
                Positioned(
                    top: 50,
                    left: MediaQuery.of(context).size.width * 0.5 -150,
                    child: const SizedBox(
                      width: 300,
                      height: 370,
                      child: UpdateSwiper()
                    )),
                Positioned(
                    bottom: 10,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: PlayMusic(playMusic: player,),
                    ),
                ),
              ],
            );
          }),
    );
  }
}
