import 'dart:async';

import 'package:flutter/material.dart';

class ChangePicture extends StatefulWidget {
  const ChangePicture({Key? key}) : super(key: key);

  @override
  ChangePictureState createState() => ChangePictureState();
}

class ChangePictureState extends State<ChangePicture> {
  int _index = 1;

  void inc() async {
    while (_index < 6) {
      print(_index);
      await Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _index++;
          });
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     inc();
    //setTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: Container(
        key: UniqueKey(),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('/images/fstmeet/boy$_index.jpg'),
          fit: BoxFit.cover,
        )),
      ),
    );
  }
}
