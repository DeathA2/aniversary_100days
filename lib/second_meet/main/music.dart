import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aniversary_100days/data.dart';
import 'package:aniversary_100days/second_meet/main/music/list_music_in_app.dart';
import 'package:aniversary_100days/second_meet/main/music/selected_music/list_music_select.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PlayMusic extends StatefulWidget {
  final AudioPlayer playMusic;
  PlayMusic({Key? key, required this.playMusic}) : super(key: key);

  @override
  _PlayMusicState createState() => _PlayMusicState();
}

class _PlayMusicState extends State<PlayMusic> {

  bool isPlay = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  var currentMusic = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i in MusicList.listMusic){
      if (i['Select'] == "true"){
        MusicList.listMusicSelect.add(i);
      }
    }
    setAudio();
    play();
  }

  void play() {
    widget.playMusic.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlay = state == PlayerState.playing;
      });
    });

    widget.playMusic.onDurationChanged.listen((newDuration) {

      setState(() {
        duration = newDuration;
      });
    });

    widget.playMusic.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;

        if (duration.inSeconds.toDouble()-position.inSeconds.toDouble() <= 0){
          if (currentMusic == MusicList.listMusicSelect.length-1){
            currentMusic = 0;
          }
          else {
            currentMusic++;
          }
          setAudio();
        }
      });
    });
  }

  Future setAudio() async {
    widget.playMusic.setReleaseMode(ReleaseMode.loop);

    // String url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3";
    // await playMusic.setSourceUrl(url);
    final player = AudioCache(prefix: '');
    final url = await player.load(MusicList.listMusicSelect[currentMusic]['Path']);
    widget.playMusic.setSourceUrl(url.path);
    // playMusic.setSourceUrl(AssetSource("assets/music"))
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   widget.playMusic.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    const textStyle = TextStyle(
      fontSize: 15,
      shadows: [
        Shadow(
          blurRadius: 7.0,
          color: Colors.white,
          offset: Offset(0, 0),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          children: [
            AnimatedTextKit(
                pause: const Duration(milliseconds: 100),
                repeatForever: true,
                animatedTexts: [
                  ColorizeAnimatedText("♬ ${MusicList.listMusicSelect[currentMusic]['Name']} ♬",
                      textStyle: textStyle,
                      colors: colorizeColors,
                      speed: const Duration(milliseconds: 300))
                ]),

            SfSlider(
                activeColor: Colors.green[900],
                inactiveColor: Colors.green[300],
                thumbIcon: Center(
                    child: Icon(
                  isPlay ? Icons.pause : Icons.play_arrow,
                  size: 10,
                )),
                min: 0,
                max: duration.inSeconds.toDouble() + 1,
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await widget.playMusic.seek(position);
                  await widget.playMusic.resume();

                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(position)),
                    Text(formatTime(duration - position))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      iconSize: 15,
                      icon: const Icon(Icons.format_list_numbered_sharp),
                      onPressed: (){
                        if (MusicList.listMusicSelect.isNotEmpty) {
                          Navigator.of(context).push(PageTransition(
                              child: ListSelectedMusic(
                                updateMusic: updateCurrentMusic,
                                selectMusic: playThisMusic
                              ),
                              alignment: Alignment.topCenter,
                              type: PageTransitionType.scale));
                        }
                      },
                    ),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      iconSize: 18,
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () {
                        setState(() {
                            if (currentMusic == 0){
                              currentMusic = 0;
                            }
                            else {
                              currentMusic--;
                            }
                          setAudio();
                          play();
                        });
                      },
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isPlay
                        ? Theme.of(context).backgroundColor
                        : Theme.of(context).primaryColor,
                    child: IconButton(
                      icon: Icon(isPlay ? Icons.pause : Icons.play_arrow),
                      onPressed: () async {
                        if (isPlay) {
                          await widget.playMusic.pause();
                        } else {
                          await widget.playMusic.resume();
                        }
                      },
                    ),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      iconSize: 18,
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        setState(() {
                            if (currentMusic == MusicList.listMusicSelect.length-1){
                              currentMusic = 0;
                            }
                            else {
                              currentMusic++;
                            }
                          setAudio();
                          play();
                        });
                      },
                    ),
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      iconSize: 15,
                      icon: const Icon(Icons.library_music),
                      onPressed: () {
                        Navigator.of(context).push(PageTransition(
                            child: ListMusicInApp(updateMusic: updateCurrentMusic,),
                            type: PageTransitionType.leftToRight));
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigit(duration.inHours);
    final minutes = twoDigit(duration.inMinutes.remainder(60));
    final seconds = twoDigit(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  void updateCurrentMusic(){
    setState(() {
      currentMusic = 0;
      duration =Duration.zero;
      position = Duration.zero;
      setAudio();
      play();
    });
  }

  void playThisMusic(thisMusic){
    setState(() {
      currentMusic = thisMusic;
      duration =Duration.zero;
      position = Duration.zero;
      setAudio();
      play();
    });
  }

}
