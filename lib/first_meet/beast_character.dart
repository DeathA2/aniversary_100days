import 'package:aniversary_100days/data.dart';
import 'package:flutter/material.dart';

class Beast extends StatefulWidget {
  const Beast({Key? key}) : super(key: key);

  @override
  BeastState createState() => BeastState();
}

class BeastState extends State<Beast> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: (FirstMeet.endFirstMeet) ? 0 : 1,
      duration: const Duration(seconds: 3),
      onEnd: () {
      },
      child: Container(
        width: 100,
        height: 200,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/character/beast.png"),
          fit: BoxFit.contain,
        )),
      ),
    );
  }

  void endMeet() {
    setState(() {
      FirstMeet.endFirstMeet = true;
    });
  }
}
