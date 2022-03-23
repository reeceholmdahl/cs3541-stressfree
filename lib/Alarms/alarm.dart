import 'package:firstapp/Alarms/createNewAlarm.dart';
import 'package:flutter/cupertino.dart';

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

import '../home/home.dart';

class Alarms extends StatelessWidget {
  const Alarms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarms',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Alarm Page'),
        ),
        body: Center(

          child: Column(
              mainAxisSize: MainAxisSize.max,

              children: [
                const SizedBox(height: 30), //adjust heights
                AlarmIcon(),
                NewAlarmButton()
              ],
          ),

      ),
      ),
    );
  }

}

class AlarmIcon extends StatelessWidget {
  const AlarmIcon({Key? key}) : super(key: key);

 Widget build(BuildContext context) {
   return Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: const <Widget>[
       Icon(
         Icons.access_alarms,
         color: Colors.pink,
         size: 100.0,
         semanticLabel: 'Text to announce in accessibility modes',
       ),

     ],
   );
 }
}

class NewAlarmButton extends StatefulWidget {
  const NewAlarmButton({Key? key}) : super(key: key);

  @override
  State<NewAlarmButton> createState() => _NewAlarmButtonState();
}

class _NewAlarmButtonState extends State<NewAlarmButton> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[


          const SizedBox(height: 30),
          buildNewAlarmPopup()
        ],
      ),
    );
  }

  Container buildNewAlarmPopup() {
    return Container(
      margin: const EdgeInsets.all(25),
      child: TextButton(
          child: const Text(
            'Create timer',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: () {
            // create timer

            showDialog(
                context: context,
                builder: (context) {
                  return AboutDialog(
                    children: [
                      Center(
                        child: Text("New Alarm",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      )
                    ],
                  );
                });
          }),
    );
  }

}


