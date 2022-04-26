import 'package:firstapp/side_drawer.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class TipOfTheDay extends StatelessWidget {
  const TipOfTheDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tip of the Day",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Tip of the Day"),
        ),
        resizeToAvoidBottomInset: false,
        drawer: SideDrawer(),
        body: TipBody(),
      ),
    );
  }
}

class TipBody extends StatelessWidget {
  var moodColor = Color.fromRGBO(201, 189, 182, 1);
  var moodIcon = Icons.visibility_off_sharp;
  TipBody({Key? key}) : super(key: key);

  String getTip() {
    var random = new Random();
    int result = random.nextInt(10);

    return listOfTips[result];
  }

  @override
  Widget build(BuildContext context) {
    String text = getTip();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Center(
              child: Container(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ),
        ]);
  }

  final listOfTips = [
    "Take a deep breath.",
    "Drink a glass of water.",
    "Take a break to enjoy nature.",
    "Reach out to someone who makes you happy.",
    "Find a creative outlet for your thoughts and feelings.",
    "Check your posture to make sure you’re not building tension in your body.",
    "Unwind to a song that makes you happy.",
    "Take some time to do something you love.",
    "Fix something small that has been bothering you.",
    "Take a moment to visualize your goals.",
    "Go for a short walk to enjoy the fresh air.",
  ];
}
