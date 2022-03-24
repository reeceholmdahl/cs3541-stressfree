import 'package:firstapp/Alarms/createNewAlarm.dart';
import 'package:flutter/cupertino.dart';

import 'dart:core';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
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
      home: Test(),
    );
  }
}

class Test extends StatelessWidget {
  buildNewAlarmPopup(BuildContext context) {
    TextEditingController hourController = TextEditingController();
    TextEditingController minuteController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("New Alarm"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.yellow,
                    //borderRadius: BorderRadius.circular(11)
                  ),
                  child: Center(
                    child: TextField(
                      controller: hourController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(11)),
                  child: Center(
                    child: TextField(
                      controller: minuteController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0, child: Text("Submit"),
                  onPressed: () {
                    int hour;
                    int minutes;
                    hour = int.parse(hourController.text);
                    minutes = int.parse(minuteController.text);

                    // creating alarm after converting hour
                    // and minute into integer
                    FlutterAlarmClock.createAlarm(hour, minutes);
                 }
              )

            ],
          );
        }); //showDialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 30), //adjust heights
            AlarmIcon(),
            TextButton(
              child: const Text(
                'AlarmButton',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                buildNewAlarmPopup(context);
              },
            ),
          ],
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
