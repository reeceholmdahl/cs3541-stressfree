import 'package:firstapp/drawer.dart';
import 'package:firstapp/journal/pastJournal.dart';
import 'package:firstapp/journal/readableData/readableList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/data/mood.dart';

import 'historyView.dart';

class journal extends StatelessWidget {
  const journal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Self Care Journal';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        resizeToAvoidBottomInset: false,
        drawer: sideDrawerLeft(),
        body: journalArea(),
      ),
    );
  }
}

class journalArea extends StatelessWidget {
  var _mood = Mood.nullMood;
  final titleController = TextEditingController();
  final controller = TextEditingController();
  var moodColor = Colors.white;
  var moodIcon = Icons.visibility_off_sharp;
  journalArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                children: <Widget>[
                  OutlineButton(
                    shape: CircleBorder(),
                    highlightColor: Colors.red,
                    highlightedBorderColor: Colors.red,
                    borderSide: BorderSide(
                        width: 3,
                        color: Colors.red
                    ),
                    child: Icon(Mood.icon_bad),
                    onPressed: () {
                      moodColor = Colors.red;
                      moodIcon = Mood.icon_bad;
                    },
                  ),
                  OutlineButton(
                    shape: CircleBorder(),
                    highlightColor: Colors.amber,
                    highlightedBorderColor: Colors.amber,
                    borderSide: BorderSide(
                        width: 3,
                        color: Colors.amber
                    ),
                    child: Icon(Mood.icon_medium),
                    onPressed: () {
                      moodColor = Colors.amber;
                      moodIcon = Mood.icon_medium;
                    }
                  ),
                  OutlineButton(
                    shape: CircleBorder(),
                    highlightColor: Colors.lime,
                    highlightedBorderColor: Colors.lime,
                    borderSide: BorderSide(
                        width: 3,
                        color: Colors.lime
                    ),
                    child: Icon(Mood.icon_good),
                    onPressed: () {
                      moodColor = Colors.lime;
                      moodIcon = Mood.icon_good;
                    },
                  ),
                  OutlineButton(
                    shape: CircleBorder(),
                    highlightColor: Colors.green,
                    highlightedBorderColor: Colors.green,
                    borderSide: BorderSide(
                        width: 3,
                        color: Colors.green
                    ),
                    child: Icon(Mood.icon_great),
                    onPressed: () {
                      moodColor = Colors.green;
                      moodIcon = Mood.icon_great;
                    },
                  ),
                ],
              ),
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
                ),
              ),
            )
        ),
        Card(
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                maxLines: 17,
                decoration: InputDecoration.collapsed(
                    hintText: "Write about your day here!",
                ),
              ),
            )
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Center(
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
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

                    inputReadable(moodIcon, moodColor, controller.text, titleController.text);
                    
                    //For origional  pastJournals(controllerText: controller, color: moodColor, icon: moodIcon);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
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
                        MaterialPageRoute(builder: (context) =>  historyView()));

                    // For Origional
                    //Navigator.push<void>(context,
                    //    MaterialPageRoute(builder: (context) =>  pastJournals(controllerText: controller, color: moodColor, icon: moodIcon)));
                  },
                ),
              ]
            ),
          ),
        ),
      ],
    );
  }
}
