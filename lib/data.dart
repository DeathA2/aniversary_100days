import 'package:firebase_database/firebase_database.dart';

class FirstMeet {
  static bool princess = false;
  static bool beast = true;
  static int count = 0;
  static int countList = 0;
  static bool endFirstMeet = false;
}

class SecondMeet {
  static bool princess = true;
  static bool beast = false;
  static int count = 0;
  static int countList = 0;
  static bool endSecondMeet = false;
}

class MusicList {
  static bool checkAll = false;
  static List listMusic = [
    {
      "Name": "Thêm bao nhiêu lâu",
      "Singer": "Đạt G",
      "Image" : "assets/logo/music/thembaonhieulau.jpg",
      "Path": "assets/audio/my_gf_music/dat-g-official-mv.mp3",
      "Select": "true",
      "Favorite" : true
    },
    {
      "Name": "Dòng thời gian",
      "Singer": "Nguyễn Hải Phong",
      "Image" : "assets/logo/music/DongThoiGian.jpg",
      "Path": "assets/audio/my_gf_music/DongThoiGian-NguyenHaiPhong_pc6k.mp3",
      "Select": "true",
      "Favorite" : true
    },
    {
      "Name": "Đưa nhau đi trốn",
      "Singer": "Đen & Linh Cáo",
      "Image" : "assets/logo/music/DuaNhauDiTron.jpg",
      "Path": "assets/audio/my_gf_music/dua-nhau-di-tron-ft-linh-cao-m-v.mp3",
      "Select": "true",
      "Favorite" : true
    },
    {
      "Name": "Đường ta chở em về",
      "Singer": "buitruonglinh",
      "Image" : "assets/logo/music/DuongToiChoEmVe.jpg",
      "Path": "assets/audio/my_gf_music/DuongTaChoEmVe-buitruonglinh-6318765.mp3",
      "Select": "true",
      "Favorite" : true
    },
    {
      "Name": "Hạnh phúc mới (cover)",
      "Singer": "Vũ",
      "Image" : "assets/logo/music/HanhPhucMoi.jpg",
      "Path": "assets/audio/my_gf_music/vu-cover-lyrics-kara-video.mp3",
      "Select": "true",
      "Favorite" : true
    },
    {
      "Name": "Tiny Love",
      "Singer": "Thịnh Suy",
      "Image" : "assets/logo/music/TinyLove.jpg",
      "Path": "assets/audio/TinyLove-ThinhSuy-7122314.mp3",
      "Select": "false",
      "Favorite" : false
    },
    {
      "Name": "Vì mẹ anh bắt chia tay",
      "Singer": "Miu Lê, Karik",
      "Image" : "assets/logo/music/ViMeAnhBatChiaTay.jpg",
      "Path": "assets/audio/vimeanhbatanhchiatay.mp3",
      "Select": "false",
      "Favorite" : false
    },
    {
      "Name": "Thích em hơi nhiều",
      "Singer": "Wren Evans",
      "Image" : "assets/logo/music/ThichEmHoiNhieu.jpg",
      "Path": "assets/audio/ThichEmHoiNhieu-WrenEvans-7034969.mp3",
      "Select": "false",
      "Favorite" : false
    },
    {
      "Name": "Nghe như Tình Yêu",
      "Singer": "HIEUTHUHAI",
      "Image" : "assets/logo/music/NgheNhuTinhYeu.jpg",
      "Path": "assets/audio/NgheNhuTinhYeu-HIEUTHUHAI-7045493.mp3",
      "Select": "false",
      "Favorite" : false
    },
    {
      "Name": "Độ tộc 2",
      "Singer": "Độ Mixi, Masew, Phúc Du, Pháo",
      "Image" : "assets/logo/music/DoToc2.jpg",
      "Path": "assets/audio/DoToc2-MasewDoMixiPhucDuPhao-7064730.mp3",
      "Select": "false",
      "Favorite" : false
    },
    {
      "Name": "Cưới thôi",
      "Singer": "Masew, Masiu, BRAY, TAP",
      "Image" : "assets/logo/music/CuoiThoi.jpg",
      "Path": "assets/audio/CuoiThoi-MasewMasiuBRayTAPVietNam-7085648.mp3",
      "Select": "false",
      "Favorite" : false
    }
  ];
  static List listMusicSelect = [];
}

class SwiperData{
  static List day = [];
  static List month=[];
  static List year =[];
  static List dateSwiper = [];
}

class User{
  // static String macAddress = '';
  static String idPhone = '';
}