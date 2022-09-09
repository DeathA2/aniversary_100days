class DragableListMusic{
  final List<DragableListMusicItem> list_music;

  DragableListMusic({required this.list_music});
}


class DragableListMusicItem{
  final String name;
  final String singer;
  final String image;

  const DragableListMusicItem({required this.name, required this.singer, required this.image});
}