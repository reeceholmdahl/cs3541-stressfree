import 'package:flutter/cupertino.dart';

import 'dart:core';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/material.dart';

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

class Test extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<Test> {
  //List<bool> isSelected = [true, false];

  int _currentValue = 1;

  buildNewAlarmPopup(BuildContext context) {
    TextEditingController hourController = TextEditingController();
    TextEditingController minuteController = TextEditingController();
    Toggle toggle;
    scrollWheel scroll; //edit this case

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("New Alarm"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),

                //SizedBox (
                // height: 40,
                //width: 60,
                //child :

                scroll = new scrollWheel(),
              ],
            ),
            actions: <Widget>[
              toggle = new Toggle(),
              MaterialButton(
                  elevation: 5.0,
                  child: Text("Submit"),
                  onPressed: () {
                    int hour = 0;
                    int minutes;

                    hour = scroll._currentValue;
                    minutes = scroll._currentValue2;

                    bool AM = toggle.isSelected[0];

                    if (!AM) {
                      hour += 12;
                    }
                    // creating alarm after converting hour
                    // and minute into integer
                    FlutterAlarmClock.createAlarm(hour, minutes);
                  }),
            ],
          );
        }); //showDialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: null,
        ),
        IconButton(
          icon: const Icon(Icons.pause),
          onPressed: null,
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: null,
        ),
      ],
      appBar: AppBar(
        title: const Text('Alarm Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            //adjust heights
            AlarmIcon(),
            const SizedBox(height: 300),
            //edit this and change format of button

            new Align(
                alignment: Alignment.bottomCenter,

                child:
              IconButton(
                icon: const Icon(Icons.add_circle_rounded),
                color: Colors.lightBlue,
                iconSize: 60,
                onPressed: () {
                  buildNewAlarmPopup(context);
                },
              )
            )
            //SavedAlarms(), //shows the saved alarms
          ],
        ),
      ),
    );
  }
}

class scrollWheel extends StatefulWidget {
  int _currentValue = 5;
  int _currentValue2 = 45;

  @override
  scrollWheelState createState() => scrollWheelState();
}

class scrollWheelState extends State<scrollWheel> {
  Widget build(BuildContext context) {
    return Flexible(
        child: Row(children: <Widget>[
      Flexible(
          child: NumberPicker(
        value: widget._currentValue,
        minValue: 1,
        maxValue: 12,
        itemHeight: 30,
        onChanged: (value) => setState(() => widget._currentValue = value),
      )),
      Flexible(
          child: NumberPicker(
        value: widget._currentValue2,
        minValue: 00,
        maxValue: 59,
        itemHeight: 30,
        onChanged: (value) => setState(() => widget._currentValue2 = value),
      )),
    ]));
  }
}

class SavedAlarms extends StatefulWidget {
  SavedAlarmState createState() => SavedAlarmState();
}

class SavedAlarmState extends State<SavedAlarms> {
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              //leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(width: 8),
                OnOffToggle(),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Toggle extends StatefulWidget {
  List<bool> isSelected = [true, false];

  @override
  ToggleState createState() => ToggleState();
}

class ToggleState extends State<Toggle> {
  Widget build(BuildContext context) {
    return Row(
      //appBar: AppBar(
      //title: const Text('ToggleButtons'),
      //),
      //body: Center(
      //child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ToggleButtons(
          //color: Colors.greenAccent,
          //selectedColor: Colors.amberAccent,
          //fillColor: Colors.purple,
          //splashColor: Colors.lightBlue,
          //highlightColor: Colors.lightBlue,
          //borderColor: Colors.white,

          selectedBorderColor: Colors.greenAccent,
          renderBorder: true,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
          disabledColor: Colors.blueGrey,
          disabledBorderColor: Colors.blueGrey,
          focusColor: Colors.red,
          children: <Widget>[
            Text("AM"),
            Text("PM"),
          ],
          isSelected: widget.isSelected,
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < widget.isSelected.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  widget.isSelected[buttonIndex] =
                      !widget.isSelected[buttonIndex];
                } else {
                  widget.isSelected[buttonIndex] = false;
                }
              }
            });
          },
        ),
      ],
    );
  }
}

class OnOffToggle extends StatefulWidget {
  //bool isSwitched = false;

  OnOffToggleState createState() => OnOffToggleState();
}

class OnOffToggleState extends State<OnOffToggle> {
  bool isSwitched = false;

  Widget build(BuildContext context) {
    return Row(
      //appBar: AppBar(
      //title: const Text('ToggleButtons'),
      //),
      //body: Center(
      //child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
              print(isSwitched);
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
      ],
    );
  }
}

class AlarmIcon extends StatelessWidget {
  const AlarmIcon({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.access_alarms),
          color: Colors.pink,
          iconSize: 100.0,

          onPressed: () {
            FlutterAlarmClock.showAlarms();
          },
        ),
      ],
    );
  }
}
