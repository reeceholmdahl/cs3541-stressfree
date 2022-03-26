import 'package:flutter/material.dart';

class Planner extends StatelessWidget {
  const Planner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Planner')), body: ActivityTracker());
  }
}

class ActivityTracker extends StatefulWidget {
  @override
  State<ActivityTracker> createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends State<ActivityTracker> {
  final _formKey = GlobalKey<FormState>();
  final _text = TextEditingController();

  String _location = 'Drank water';

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
                      flex: 7,
                      child: Column(
                        children: [
                          TextFormField(
                              controller: _text,
                              decoration: const InputDecoration(
                                  hintText: 'Add an activity',
                                  border: OutlineInputBorder()),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }

                                return null;
                              }),
                          DropdownButton(
                              value: _location,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _location = newValue!;
                                  _text.text = newValue;
                                });
                              },
                              items: DailyActivity.presetActivities.entries
                                  .map((entry) {
                                final a = entry.value;
                                return DropdownMenuItem(
                                    value: a.name, child: Text(a.name));
                              }).toList())
                        ],
                      ))),
              Spacer(flex: 1),
              Expanded(
                  flex: 4,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: Category.categories.entries.map((entry) {
                        final c = entry.value;
                        return ElevatedButton(
                            onPressed: () {
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                                primary: c.color, onPrimary: Colors.white),
                            child: Text(c.name,
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.center));
                      }).toList()
                      ))
            ]));
  }
}

class Category {
  final String name;
  final Color color;

  const Category(this.name, this.color);

  static final selfCare = Category('Self care', Colors.red);
  static final exercise = Category('Exercise', Colors.yellow);
  static final hobby = Category('Hobby', Colors.green);
  static final social = Category('Social', Colors.blue);
  static final job = Category('Job', Colors.deepPurple);
  static final cleaning = Category('Cleaning', Colors.orange);
  static final school = Category('School', Colors.pink);
  static final recreation = Category('Recreation', Colors.teal);

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
}

class DailyActivity {
  final String name;
  final Category category;

  const DailyActivity(this.name, this.category);

  static final presetActivities = {
    'Drank water': DailyActivity('Drank water', Category.selfCare),
    'Went outside': DailyActivity('Went outside', Category.recreation),
    'Did homework': DailyActivity('Did homework', Category.school),
    'Talked to a friend': DailyActivity('Talked to a friend', Category.social),
    'Took a shower': DailyActivity('Took a shower', Category.selfCare),
    'Brushed my teeth': DailyActivity('Brushed my teeth', Category.selfCare),
    'Did the dishes': DailyActivity('Did the dishes', Category.cleaning),
    'Meditated': DailyActivity('Meditated', Category.selfCare),
    'Did yoga': DailyActivity('Did yoga', Category.exercise),
    'Did my daily journal':
        DailyActivity('Did my daily journal', Category.selfCare)
  };
}
