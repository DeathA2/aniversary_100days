import 'package:aniversary_100days/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

typedef UpdateMusic = Function();

class ListMusicInApp extends StatefulWidget {
  final UpdateMusic updateMusic;
  const ListMusicInApp({Key? key, required this.updateMusic}) : super(key: key);

  @override
  _ListMusicInAppState createState() => _ListMusicInAppState();
}

class _ListMusicInAppState extends State<ListMusicInApp> {
  @override
  void initState() {
    super.initState();
    for (var i in MusicList.listMusic) {
      if (i['Select'] == "false") {
        MusicList.checkAll = false;
        break;
      }
      MusicList.checkAll = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("List Music"),
          leading: IconButton(
            icon: Icon(Icons.library_music),
            onPressed: () {
              MusicList.listMusicSelect = selectedMusic();
              widget.updateMusic();
              // ScaffoldMessenger.of(context)
              //   ..removeCurrentSnackBar()
              //   ..showSnackBar(SnackBar(
              //     content: Text("Nuts nayf anh de bip thoi !!!"),
              //     duration: Duration(milliseconds: 500),
              //   ));
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Center(child: Text("All")),
            Checkbox(
              value: MusicList.checkAll,
              onChanged: (value) {
                setState(() {
                  MusicList.checkAll = value!;
                  if (MusicList.checkAll) {
                    for (var i in MusicList.listMusic) {
                      i['Select'] = "true";
                    }
                  } else {
                    for (var i in MusicList.listMusic) {
                      i['Select'] = "false";
                    }
                  }
                });
              },
            ),
          ]),
      body: Column(
        children: [
          _tagList(),
          Expanded(child: _musicList(context)),
        ],
      ),
    );
  }

  List selectedMusic() {
    List selected = [];
    for (var i in MusicList.listMusic) {
      Map obj = i;
      if (obj['Select'] == "true") {
        selected.add(obj);
      }
    }
    return selected;
  }

  Widget _tagList() {
    List<String> TagMusic = [
      'assets/logo/tag_music/all-music.jpg',
      'assets/logo/tag_music/my-gf-music.png',
      'assets/logo/tag_music/my-music.jpg'
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
          child: Container(
            color: Colors.grey,
            child: Swiper(
              layout: SwiperLayout.STACK,
        index: 0,
        itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 100,
              width: 100,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Image.asset(
                TagMusic[index],
                fit: BoxFit.contain,
              ),
            );
        },
        itemCount: 3,
        onIndexChanged: (index) {
            print(index);
        },
        viewportFraction: 0.85,
        scale: 0.9,
      ),
          )),
    );
  }

  Widget _musicList(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: MusicList.listMusic.length,
      itemBuilder: (_, index) => CheckboxListTile(
          activeColor: Theme.of(context).primaryColor,
          secondary: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(MusicList.listMusic[index]['Image']),
            // child: Image.asset(MusicList.listMusic[index]['Image']),
          ),
          title: Text(MusicList.listMusic[index]['Name']),
          subtitle: Text(
            MusicList.listMusic[index]['Singer'],
            style: TextStyle(fontSize: 12),
          ),
          value: MusicList.listMusic[index]['Select'] == "true",
          onChanged: (value) {
            setState(() {
              MusicList.listMusic[index]['Select'] =
                  MusicList.listMusic[index]['Select'] == "true"
                      ? "false"
                      : "true";
              if (MusicList.listMusic[index]['Select'] == "false")
                MusicList.checkAll = false;
            });
          }),
    );
  }
}
