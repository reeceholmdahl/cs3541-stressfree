
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';


class CreateNewAlarm extends StatelessWidget {
  const CreateNewAlarm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarms',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('New Alarm'),
        ),
        body: Center(
          //children:  NewAlarmButton(),
          //AlarmIcon(),
          //NewAlarmButton(),
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                margin: const EdgeInsets.all(25),
                child: TextButton(
                  child: const Text(
                    'Create alarm at 23:59',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    FlutterAlarmClock.createAlarm(23, 59);
                  },
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }

}