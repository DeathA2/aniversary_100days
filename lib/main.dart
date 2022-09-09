// ignore_for_file: prefer_const_constructors
import 'package:aniversary_100days/end_screen/end_screen.dart';
import 'package:aniversary_100days/screen/real_splash_screen.dart';
import 'package:aniversary_100days/second_meet/main/music/list_music_in_app.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anniversary 100days',
      theme: ThemeData(
        primaryColor: Colors.green[800],
        backgroundColor: Colors.green[900],
      ),
      home: RealSplashScreen()
      // home: ListMusicInApp(),
    );
  }
}
