
import 'dart:core';

import 'package:flutter/material.dart';


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

            ],
          ),

        ),
      ),
    );
  }

}