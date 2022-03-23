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
          //children:  NewAlarmButton(),
                  //AlarmIcon(),
                 //NewAlarmButton(),
          child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
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
     mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          ElevatedButton(
            style: style,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return CreateNewAlarm();
              }));
            },
            child: const Text('Create New Alarm'),
          ),
        ],
      ),
    );
  }
}


