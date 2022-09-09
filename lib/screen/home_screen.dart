import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aniversary_100days/data.dart';
import 'package:aniversary_100days/first_meet/screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_mac/get_mac.dart';
import 'package:page_transition/page_transition.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final db = FirebaseDatabase.instance.ref();

  Future getInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  }

  Future<void> getIdAddress() async {
    // var macAddress = await GetMac.macAddress;
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var id = await getInfo();
    db.child("/id/${id.replaceAll('.', '-')}").set({
      "princess": "Phương Thảo",
      "visit": 0,
      "crush": "Nobody",
      "anniversary": false,
      "feeling": " "
    });
    // User.macAddress = macAddress.toString();
    User.idPhone = id.replaceAll('.', '-');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIdAddress();
  }

  final player = AudioPlayer();

  void playSoundEffect() async{
    player.setReleaseMode(ReleaseMode.loop);

    final players = AudioCache(prefix: '');
    final url = await players.load('assets/audio/sound_effect/storytelling-background-music-no-copyright-music.mp3');
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Center(
                child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height,
              child: Flex(direction: Axis.horizontal, children: [
                Flexible(
                  child: DefaultTextStyle(
                    softWrap: true,
                    style: const TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'Script',
                        color: Colors.white),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        RotateAnimatedText('Ngày nảy ngay nay',
                            textAlign: TextAlign.center,
                            duration: const Duration(seconds: 2)),
                        RotateAnimatedText('Tại một vương quốc nhỏ',
                            textAlign: TextAlign.center,
                            duration: const Duration(seconds: 2)),
                        RotateAnimatedText(
                            'Có một nàng công chúa đã 21 năm vẫn chưa từng có tình yêu',
                            textAlign: TextAlign.center,
                            transitionHeight: 250,
                            duration: const Duration(seconds: 4)),
                        RotateAnimatedText(
                            'Dù cô được rất nhiều chàng trai theo đuổi',
                            textAlign: TextAlign.center,
                            transitionHeight: 200,
                            duration: const Duration(seconds: 4)),
                        RotateAnimatedText('Nhưng cô không chọn bất kỳ ai cả',
                            textAlign: TextAlign.center,
                            transitionHeight: 200,
                            duration: const Duration(seconds: 3)),
                        RotateAnimatedText('Đến một hôm',
                            textAlign: TextAlign.center,
                            duration: const Duration(seconds: 2)),
                        RotateAnimatedText(
                            'Cô nghe người dân trong vương quốc đồn về một nhà tiên tri ở sâu trong núi',
                            textAlign: TextAlign.center,
                            transitionHeight: 300,
                            duration: const Duration(seconds: 4)),
                        RotateAnimatedText(
                            'Cô quyết định trốn cha mẹ, một mình vào chốn rừng sâu',
                            transitionHeight: 250,
                            textAlign: TextAlign.center,
                            duration: const Duration(seconds: 4)),
                        RotateAnimatedText('Để tìm một nửa của đời mình',
                            transitionHeight: 200,
                            textAlign: TextAlign.center,
                            duration: const Duration(seconds: 3)),
                        RotateAnimatedText(
                            'Cô đã tìm thấy một tòa lâu đài nhỏ cũ kỹ ở sâu trong rừng',
                            transitionHeight: 230,
                            textAlign: TextAlign.center,
                            duration: const Duration(seconds: 4)),
                        FadeAnimatedText(
                            'Bỗng cô nghe thấy giọng nói ở phía sau ....',
                            textAlign: TextAlign.center,
                            duration: const Duration(seconds: 3)),
                      ],
                      pause: const Duration(milliseconds: 500),
                      totalRepeatCount: 1,
                      onFinished: () {
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MeetScreen()));
                        Navigator.of(context).pushReplacement(PageTransition(
                            child: MeetScreen(),
                            type: PageTransitionType.fade));
                      },
                    ),
                  ),
                ),
              ]),
            ))
          ],
        ),
      ),
    );
  }
}

class MyRoute extends MaterialPageRoute {
  MyRoute(WidgetBuilder builder) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(seconds: 2);
}
