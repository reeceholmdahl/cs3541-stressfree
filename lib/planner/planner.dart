import 'dart:developer';

import 'package:firstapp/mood.dart';
import 'package:flutter/material.dart';

class Planner extends StatelessWidget {
  const Planner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text('Planner')),
        body: ActivityTracker());
  }
}

class ActivityTracker extends StatefulWidget {
  @override
  State<ActivityTracker> createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends State<ActivityTracker> {
  final _formKey = GlobalKey<FormState>();
  final _text = TextEditingController();

  DailyActivity _activity = DailyActivity.nullActivity;
  Mood _mood = Mood.nullMood;

  List<DailyActivity> _activities = List.empty(growable: true);

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                  key: _formKey,
                  child: Expanded(
                      flex: 10,
                      child: Column(
                        children: [
                          TextFormField(
                              controller: _text,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  fillColor: _activity.category.color,
                                  filled: true,
                                  hintText: 'Add an activity',
                                  border: OutlineInputBorder()),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }

                                return null;
                              },
                              onChanged: (String? newValue) {
                                setState(() {
                                  _activity = DailyActivity(
                                      newValue!, _activity.category);
                                });
                              }),
                          DecoratedBox(
                            decoration:
                                BoxDecoration(color: _activity.category.color),
                            child: DropdownButton<DailyActivity>(
                              items: DailyActivity.presetActivities.entries
                                  .map((entry) {
                                final a = entry.value;
                                return DropdownMenuItem<DailyActivity>(
                                    value: a,
                                    child: Container(
                                        color: a.category.color,
                                        child: Text(a.name)));
                              }).toList(),
                              onChanged: (DailyActivity? newValue) {
                                setState(() {
                                  _activity = newValue!;
                                  _text.text = newValue.name;
                                });
                              },
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  logActivity();
                                }
                              },
                              child: Text('Add activity')),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: _activities.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final activity = _activities[index];
                                    return ListTile(
                                        onTap: () {
                                          setState(() {
                                            _activities.removeAt(index);
                                          });
                                        },
                                        leading: Icon(Icons.menu),
                                        title: Text(activity.name),
                                        tileColor: activity.category.color,
                                        trailing: Icon(Icons.android));
                                  }))
                        ],
                      ))),
              Spacer(flex: 1),
              Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: Category.categories.entries.map((entry) {
                            final c = entry.value;
                            return ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _activity =
                                        DailyActivity(_activity.name, c);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: c.color, onPrimary: Colors.white),
                                child: Text(c.name,
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.center));
                          }).toList()),
                      Column(
                          children: Mood.moods.entries.map((entry) {
                        final m = entry.value;
                        return Card(
                            color: _mood == m
                                ? m.color.shade700
                                : m.color.shade400,
                            child: InkWell(
                                splashColor: m.color.shade50.withAlpha(30),
                                onTap: () {
                                  setState(() {
                                    _mood = m;
                                  });
                                },
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Column(
                                    children: [
                                      const Icon(Icons.android_outlined,
                                          size: 20),
                                      Text(m.name,
                                          style: TextStyle(fontSize: 12))
                                    ],
                                  ),
                                )));
                      }).toList())
                    ],
                  ))
            ]));
  }

  void logActivity() {
    log(_activity.name + ' ' + _activity.category.name + ' ' + _mood.name);
    if (_activity.category != Category.nullCategory && _mood != Mood.nullMood) {
      setState(() {
        _activities.add(_activity);
      });
      log('Added activity');
    }
  }
}

class Category {
  final String name;
  final Color color;

  const Category(this.name, this.color);

  static final selfCare = Category('self care', Colors.red);
  static final exercise = Category('exercise', Colors.yellow);
  static final hobby = Category('hobby', Colors.green);
  static final social = Category('social', Colors.blue);
  static final job = Category('job', Colors.deepPurple);
  static final cleaning = Category('cleaning', Colors.orange);
  static final school = Category('school', Colors.pink);
  static final recreation = Category('recreation', Colors.teal);

  static final categories = {
    'selfCare': selfCare,
    'exercise': exercise,
    'hobby': hobby,
    'social': social,
    'job': job,
    'cleaning': cleaning,
    'school': school,
    'recreation': recreation
  };

  static final nullCategory = Category('Null', Colors.white);
}

class DailyActivity {
  final String name;
  final Category category;

  const DailyActivity(this.name, this.category);

  static final presetActivities = {
    'drank water': DailyActivity('Drank water', Category.selfCare),
    'went outside': DailyActivity('Went outside', Category.recreation),
    'did homework': DailyActivity('Did homework', Category.school),
    'talked to a friend': DailyActivity('Talked to a friend', Category.social),
    'took a shower': DailyActivity('Took a shower', Category.selfCare),
    'brushed my teeth': DailyActivity('Brushed my teeth', Category.selfCare),
    'did the dishes': DailyActivity('Did the dishes', Category.cleaning),
    'meditated': DailyActivity('Meditated', Category.selfCare),
    'did yoga': DailyActivity('Did yoga', Category.exercise),
    'did my daily journal':
        DailyActivity('Did my daily journal', Category.selfCare)
  };

  static final nullActivity = DailyActivity('Null', Category.nullCategory);
}
