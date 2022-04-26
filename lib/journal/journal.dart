import 'dart:developer';

import 'package:firstapp/constants.dart';
import 'package:firstapp/mood_rater.dart';
import 'package:firstapp/side_drawer.dart';
import 'package:flutter/material.dart';

import 'history_view.dart';
import 'readable_data/readable_list.dart';

class DailyJournal extends StatelessWidget {
  const DailyJournal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self Care Journal'),
      ),
      resizeToAvoidBottomInset: false,
      drawer: SideDrawer(),
      body: JournalArea(),
    );
  }
}

class JournalArea extends StatelessWidget {
  var _mood = Moods.Null;
  final titleController = TextEditingController();
  final controller = TextEditingController();
  // var moodColor = Color.fromRGBO(201, 189, 182, 1);
  // var moodIcon = Icons.visibility_off_sharp;
  JournalArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final MoodRater moodRater;
    moodRater = MoodRater(onChanged: () {
      _mood = moodRater.selectedMood();
      log(_mood.name);
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Center(
            child: Container(
              child: Text(
                'How do you feel today?',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Center(
            child: moodRater,
          ),
        ),
        Card(
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                maxLines: 1,
                decoration: InputDecoration.collapsed(
                  hintText: "Title",
                  fillColor: Color.fromRGBO(157, 180, 165, 100),
                  filled: true,
                ),
              ),
            )),
        Card(
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                maxLines: 17,
                decoration: InputDecoration.collapsed(
                  hintText: "Write about your day here!",
                  fillColor: Color.fromRGBO(157, 180, 165, 100),
                  filled: true,
                ),
              ),
            )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Center(
            child: Row(children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(157, 180, 165, 100),
                  fixedSize: const Size(180, 60),
                ),
                child: Text(
                  'Save',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  inputReadable(_mood.iconData, _mood.color, controller.text,
                      titleController.text);

                  //For origional  pastJournals(controllerText: controller, color: moodColor, icon: moodIcon);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(157, 180, 165, 100),
                  fixedSize: const Size(180, 60),
                ),
                child: Text(
                  'View Submissions',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.push<void>(context,
                      MaterialPageRoute(builder: (context) => HistoryView()));

                  // For Origional
                  //Navigator.push<void>(context,
                  //    MaterialPageRoute(builder: (context) =>  pastJournals(controllerText: controller, color: moodColor, icon: moodIcon)));
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
