import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:aniversary_100days/data.dart';
import 'package:aniversary_100days/screen/fully_device_screen.dart';
import 'package:aniversary_100days/screen/home_screen.dart';
import 'package:aniversary_100days/login_next_time/next_time_screen.dart';
import 'package:aniversary_100days/screen/no_internet_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_mac/get_mac.dart';
import 'package:page_transition/page_transition.dart';

class RealSplashScreen extends StatefulWidget {
  RealSplashScreen({Key? key}) : super(key: key);

  @override
  State<RealSplashScreen> createState() => _RealSplashScreenState();
}

class _RealSplashScreenState extends State<RealSplashScreen> {
  final player = AudioPlayer();
  var visit;
  var accessedDevice = true;

  final db = FirebaseDatabase.instance.ref();

  Future<void> getId() async {
    String id = await getInfo();
    User.idPhone = id.replaceAll('.', '-');
  }

  Future<void> getFb() async {
    var _visit =
        await db.child("/id/${User.idPhone}").child("visit").get();
    if (_visit.exists) {
      visit = _visit.value;
    }
  }

  Future getInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  }
  //
  // Future checkNumberDevice() async {
  //   var _number = await db.child("/device").get();
  //   var _numberAccess = await db.child("/numberDevide").get();
  //   var numberDevice = 0;
  //   int numberAccess = 0;
  //   if (_number.exists) {
  //     numberDevice = _number.children.length;
  //   }
  //   if (_numberAccess.exists) {
  //     numberAccess = _numberAccess.value as int;
  //   }
  //   // accessedDevice = (numberDevice <= numberAccess) ? true : false;
  //   if (numberDevice < numberAccess){
  //     accessedDevice = true;
  //     return;
  //   }
  //   if (numberDevice == numberAccess){
  //     var _listMac = await db.child("/device").get();
  //     for (var mac in _listMac.children){
  //       if (User.macAddress == mac.key){
  //         accessedDevice = true;
  //         return;
  //       }
  //     }
  //   }
  //   accessedDevice = false;
  // }

  Future checkNumberDevice() async {
    var _id = await db.child("/id").get();
    var _numberIdAccess = await db.child("/numberDevide").get();
    var numberDevice = 0;
    int numberAccess = 0;
    if (_id.exists) {
      numberDevice = _id.children.length;
    }
    if (_numberIdAccess.exists) {
      numberAccess = _numberIdAccess.value as int;
    }
    if (numberDevice < numberAccess){
      accessedDevice = true;
      return;
    }
    if (numberDevice == numberAccess){
      var _listId = await db.child("/id").get();
      for (var id in _listId.children){
        if (User.idPhone == id.key){
          accessedDevice = true;
          return;
        }
      }
    }
    accessedDevice = false;
  }

  void playSoundEffect() async{
    player.setReleaseMode(ReleaseMode.loop);

    final players = AudioCache(prefix: '');
    final url = await players.load('assets/audio/sound_effect/happy-logo-13397.mp3');
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
    getInfo();
    playSoundEffect();
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/artboard_1xhdpi.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 1)),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Positioned(
                    top: -90,
                    right: 10,
                    left: 0,
                    bottom: 0,
                    child: AnimatedSplashScreen.withScreenFunction(
                        splash: Image.asset("assets/images/be.png"),
                        curve: Curves.linear,
                        duration: 2000,
                        splashTransition: SplashTransition.slideTransition,
                        backgroundColor: Colors.transparent,
                        pageTransitionType: PageTransitionType.topToBottom,
                        animationDuration: const Duration(seconds: 1),
                        screenFunction: () async {
                          return FutureBuilder(
                              future: getId(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return FutureBuilder(
                                      future:
                                          Future.delayed(const Duration(seconds: 2)),
                                      builder: ((context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return const SizedBox();
                                        }
                                        return const NoInternetConnectionScreen();
                                      }));
                                }
                                return FutureBuilder(
                                    future: getFb(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return FutureBuilder(
                                            future: checkNumberDevice(),
                                            builder: ((context, snapshot) {
                                              if (snapshot.connectionState !=
                                                  ConnectionState.done) {
                                                return const SizedBox();
                                              }
                                              return (!accessedDevice)
                                                  ? const FullyDeviceScreen()
                                                  : (visit == 0 ||
                                                          visit == null)
                                                      ? const MyHomeScreen()
                                                      : const NextTimeScreen();
                                            }));
                                      }
                                      return FutureBuilder(
                                          future: Future.delayed(
                                              const Duration(seconds: 2)),
                                          builder: ((context, snapshot) {
                                            if (snapshot.connectionState !=
                                                ConnectionState.done) {
                                              return const SizedBox();
                                            }
                                            return const NoInternetConnectionScreen();
                                          }));
                                    });
                              }));
                        }),
                  ),
                  FutureBuilder(
                      future: Future.delayed(const Duration(milliseconds: 1700)),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const SizedBox();
                        }
                        return Positioned(
                            top: 50,
                            right: 10,
                            left: 0,
                            bottom: 0,
                            child: AnimatedSplashScreen.withScreenFunction(
                                splash:
                                    Image.asset("assets/images/together.png"),
                                curve: Curves.easeInOutCirc,
                                duration: 2000,
                                splashTransition:
                                    SplashTransition.scaleTransition,
                                backgroundColor: Colors.transparent,
                                pageTransitionType:
                                    PageTransitionType.topToBottom,
                                animationDuration: const Duration(seconds: 1),
                                screenFunction: () async {
                                  return FutureBuilder(
                                      future: getId(),
                                      builder: ((context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return FutureBuilder(
                                              future: Future.delayed(
                                                  const Duration(seconds: 2)),
                                              builder: ((context, snapshot) {
                                                if (snapshot.connectionState !=
                                                    ConnectionState.done) {
                                                  return const SizedBox();
                                                }
                                                return const NoInternetConnectionScreen();
                                              }));
                                        }
                                        return FutureBuilder(
                                            future: getFb(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                return FutureBuilder(
                                                    future: checkNumberDevice(),
                                                    builder: ((context, snapshot) {
                                                      if (snapshot.connectionState !=
                                                          ConnectionState.done) {
                                                        return const SizedBox();
                                                      }
                                                      return (!accessedDevice)
                                                          ? const FullyDeviceScreen()
                                                          : (visit == 0 ||
                                                          visit == null)
                                                          ? const MyHomeScreen()
                                                          : const NextTimeScreen();
                                                    }));
                                              }
                                              return FutureBuilder(
                                                  future: Future.delayed(
                                                      const Duration(seconds: 2)),
                                                  builder:
                                                      ((context, snapshot) {
                                                    if (snapshot
                                                            .connectionState !=
                                                        ConnectionState.done) {
                                                      return const SizedBox();
                                                    }
                                                    return const NoInternetConnectionScreen();
                                                  }));
                                            });
                                      }));
                                }));
                      }))
                ],
              );
            }
            return const SizedBox();
          }),
    );
  }
}
