import 'package:aniversary_100days/data.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

typedef UpdateMusic = Function();
typedef SelectMusic = Function(int index);

class ListSelectedMusic extends StatefulWidget {
  final UpdateMusic updateMusic;
  final SelectMusic selectMusic;
  const ListSelectedMusic(
      {Key? key, required this.updateMusic, required this.selectMusic})
      : super(key: key);

  @override
  _ListSelectedMusicState createState() => _ListSelectedMusicState();
}

class _ListSelectedMusicState extends State<ListSelectedMusic> {
  @override
  Widget build(BuildContext context) {
    print(MusicList.listMusicSelect.length);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("List Selected Music"),
        leading: IconButton(
          icon: const Icon(Icons.library_music),
          onPressed: () {
            widget.updateMusic();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
          itemCount: MusicList.listMusicSelect.length,
          itemBuilder: (_, index) => Dismissible(
                key: UniqueKey(),
                background: Container(
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).primaryColor,
                  child: const Icon(Icons.heart_broken),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: const Icon(Icons.cancel_outlined),
                ),
                onDismissed: (direction) {
                  setState(() {
                    int i = MusicList.listMusic.indexWhere((element) =>
                        element['Name'] ==
                        MusicList.listMusicSelect[index]['Name']);
                    MusicList.listMusic[i]['Select'] = "false";
                    MusicList.listMusicSelect.removeAt(index);
                  });
                },
                child: TextButton(
                  onPressed: () {
                    widget.selectMusic(index);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                              MusicList.listMusicSelect[index]['Image']),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Text(
                              MusicList.listMusicSelect[index]['Name'],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                            Text(
                              MusicList.listMusicSelect[index]['Singer'],
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  MusicList.listMusicSelect[index]['Favorite'] =
                                      !MusicList.listMusicSelect[index]
                                          ['Favorite'];
                                });
                              },
                              icon: Icon(MusicList.listMusicSelect[index]
                                      ['Favorite']
                                  ? Ionicons.heart_sharp
                                  : Ionicons.heart_outline)))
                    ],
                  ),
                ),
              )),
    );
  }
}
