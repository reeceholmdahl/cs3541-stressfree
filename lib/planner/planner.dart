import 'dart:developer';
import 'dart:math' as math;

import 'package:firstapp/drawer.dart';
import 'package:firstapp/planner/constants.dart';
import 'package:firstapp/planner/data/planned_activity.dart';
import 'package:firstapp/planner/planner_settings.dart';
import 'package:flutter/material.dart';

import 'data/activity_category.dart';

class Planner extends StatelessWidget {
  const Planner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: sideDrawerLeft(),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Planner'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (context) => const PlannerSettings()));
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: Builder(builder: (context) {
          return Column(
            children: [PlanActivity(), ActivityList()],
          );
        }));
  }
}

class PlanActivity extends StatefulWidget {
  @override
  State<PlanActivity> createState() => _PlanActivityState();
}

class _PlanActivityState extends State<PlanActivity> {
  final _entryControl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _dropdownKey = GlobalKey<FormFieldState<ActivityCategory>>();

  ActivityCategory _category = activityCategoriesList[4];

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.light();
    return Form(
      key: _formKey,
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: theme.backgroundColor,
              border: Border(
                  bottom: BorderSide(color: theme.dividerColor, width: 5))),
          child: Container(
            height: 80,
            child: Row(children: [
              Expanded(
                flex: 7,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.purple.shade300),
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: _entryControl,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            border: InputBorder.none),
                      ),
                      Positioned(
                        right: 0,
                        child: PopupMenuButton<PlannedActivity>(
                            onSelected: (value) {
                              _entryControl.text = value.name;
                              _dropdownKey.currentState!
                                  // ignore: invalid_use_of_protected_member
                                  .setValue(value.category);
                            },
                            elevation: 2,
                            icon: Icon(Icons.arrow_drop_down_rounded,
                                size: 50, color: Colors.green.shade700),
                            offset: Offset.fromDirection(math.pi / 2, 50),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context) => [
                                  for (final activity in presetActivitiesList)
                                    PopupMenuItem(
                                        value: activity,
                                        child: Text(activity.name))
                                ]),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                  child: DropdownButtonFormField<ActivityCategory>(
                      key: _dropdownKey,
                      decoration: InputDecoration(border: InputBorder.none),
                      elevation: 2,
                      value: _category,
                      onChanged: (value) {
                        log(value!.name);
                      },
                      items: [
                        for (final category in activityCategoriesList)
                          DropdownMenuItem(
                              value: category, child: Text(category.name))
                      ]),
                ),
              ),
              _AnimatedSubmitButton(onPressed: () {
                log('submit button');
              })
            ]),
          )),
    );
  }
}

class _AnimatedSubmitButton extends StatefulWidget {
  final VoidCallback onPressed;

  _AnimatedSubmitButton({required this.onPressed});

  @override
  State<_AnimatedSubmitButton> createState() => _AnimatedSubmitButtonState();
}

class _AnimatedSubmitButtonState extends State<_AnimatedSubmitButton>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _rotation = Tween<double>(begin: 0, end: 0.25).animate(_ctrl);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.blue,
        child: RotationTransition(
            turns: _rotation,
            child: IconButton(
              onPressed: () async {
                widget.onPressed();
                await Future.delayed(Duration(milliseconds: 100));
                _ctrl.forward();
                await Future.delayed(Duration(milliseconds: 400));
                _ctrl.reverse();
              },
              icon: const Icon(Icons.arrow_right_rounded,
                  size: 50, color: Colors.white),
              padding: EdgeInsets.zero,
            )));
  }

  @override
  void dispose() {
    super.dispose();
    _ctrl.dispose();
  }
}

class ActivityList extends StatefulWidget {
  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  final List<Activity> _activities = [
    for (int i = 0; i < 50; ++i) presetActivitiesList[i % 7]
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReorderableListView.builder(
          restorationId: 'activitiesList',
          onReorder: (oldIndex, newIndex) {},
          itemCount: _activities.length,
          itemBuilder: (context, index) {
            final activity = _activities[index];
            return ListTile(
              key: ValueKey(index),
              title: Text(activity.name),
              tileColor: activity.category.color,
            );
          }),
    );
  }
}

// TODO needs to be split into several sub-widgets and use notifiers for communication- this is hard to maintain
// TODO needs to be coupled be with the planner feature in next sprint
// class ActivityTracker extends StatefulWidget {
//   @override
//   State<ActivityTracker> createState() => _ActivityTrackerState();
// }

// class _ActivityTrackerState extends State<ActivityTracker> {
//   final _formKey = GlobalKey<FormState>();
//   final _text = TextEditingController();

//   DailyActivity _activity = DailyActivity.nullActivity;
//   Mood _mood = Mood.nullMood;

//   List<DailyActivity> _activities = List.empty(growable: true);

//   @override
//   void dispose() {
//     _text.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Form(
//                   key: _formKey,
//                   child: Expanded(
//                       flex: 10,
//                       child: Column(
//                         children: [
//                           TextFormField(
//                               controller: _text,
//                               style: TextStyle(color: Colors.white),
//                               decoration: InputDecoration(
//                                   fillColor: _activity.category.color,
//                                   filled: true,
//                                   hintText: 'Add an activity',
//                                   border: OutlineInputBorder()),
//                               validator: (String? value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter some text';
//                                 }

//                                 return null;
//                               },
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   _activity = DailyActivity(
//                                       newValue!, _activity.category);
//                                 });
//                               }),
//                           DecoratedBox(
//                             decoration:
//                                 BoxDecoration(color: _activity.category.color),
//                             child: DropdownButton<DailyActivity>(
//                               items: DailyActivity.presetActivities.entries
//                                   .map((entry) {
//                                 final a = entry.value;
//                                 return DropdownMenuItem<DailyActivity>(
//                                     value: a,
//                                     child: Container(
//                                         color: a.category.color,
//                                         child: Text(a.name)));
//                               }).toList(),
//                               onChanged: (DailyActivity? newValue) {
//                                 setState(() {
//                                   _activity = newValue!;
//                                   _text.text = newValue.name;
//                                 });
//                               },
//                             ),
//                           ),
//                           ElevatedButton(
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   logActivity();
//                                 }
//                               },
//                               child: Text('Add activity')),
//                           Expanded(
//                               child: ListView.builder(
//                                   itemCount: _activities.length,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     final activity = _activities[index];
//                                     return ListTile(
//                                         onTap: () {
//                                           setState(() {
//                                             _activities.removeAt(index);
//                                           });
//                                         },
//                                         leading: Icon(Icons.menu),
//                                         title: Text(activity.name),
//                                         tileColor: activity.category.color,
//                                         trailing: Icon(Icons.android));
//                                   }))
//                         ],
//                       ))),
//               Spacer(flex: 1),
//               Expanded(
//                   flex: 4,
//                   child: Column(
//                     children: [
//                       Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: Category.categories.entries.map((entry) {
//                             final c = entry.value;
//                             return ElevatedButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _activity =
//                                         DailyActivity(_activity.name, c);
//                                   });
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                     primary: c.color, onPrimary: Colors.white),
//                                 child: Text(c.name,
//                                     style: TextStyle(fontSize: 14),
//                                     textAlign: TextAlign.center));
//                           }).toList()),
//                       Column(
//                           children: Mood.moods.entries.map((entry) {
//                         final m = entry.value;
//                         return Card(
//                             color: _mood == m
//                                 ? m.color.shade700
//                                 : m.color.shade400,
//                             child: InkWell(
//                                 splashColor: m.color.shade50.withAlpha(30),
//                                 onTap: () {
//                                   setState(() {
//                                     _mood = m;
//                                   });
//                                 },
//                                 child: SizedBox(
//                                   width: 50,
//                                   height: 50,
//                                   child: Column(
//                                     children: [
//                                       const Icon(Icons.android_outlined,
//                                           size: 20),
//                                       Text(m.name,
//                                           style: TextStyle(fontSize: 12))
//                                     ],
//                                   ),
//                                 )));
//                       }).toList())
//                     ],
//                   ))
//             ]));
//   }

//   void logActivity() {
//     log(_activity.name + ' ' + _activity.category.name + ' ' + _mood.name);
//     if (_activity.category != Category.nullCategory && _mood != Mood.nullMood) {
//       setState(() {
//         _activities.add(_activity);
//       });
//       log('Added activity');
//     }
//   }
// }
