import 'dart:developer';

import 'package:firstapp/drawer.dart';
import 'package:firstapp/planner/constants.dart';
import 'package:firstapp/data/planned_activity.dart';
import 'package:firstapp/planner/planner_settings.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../data/mood.dart';
import 'expandable_fab.dart';

class _Notifier with ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class Planner extends StatelessWidget {
  Planner({Key? key}) : super(key: key);

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
                        builder: (context) => PlannerSettings()));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Builder(builder: (context) {
        // _newPlannedActivity.addListener(() {
        // });

        return ActivityList();
      }),
      floatingActionButton: PlannerFab(),
    );
  }
}

class PlannerFab extends StatelessWidget {
  final _closeFab = _Notifier();

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(distance: 112, closeFab: _closeFab, children: [
      ActionButton(
        icon: Icon(Icons.schedule),
        color: Colors.teal,
        onPressed: () => _closeFab.notify(),
      ),
      ActionButton(
        icon: Icon(Icons.check_circle_outline),
        color: Colors.green,
        onPressed: () {
          _closeFab.notify();
        },
      ),
      ActionButton(
        icon: Icon(Icons.calendar_month),
        color: Colors.blue,
        onPressed: () => showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text('New planned activity!'),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('ADD'),
                    ),
                  ],
                )),
      )
    ]);
  }
}

class ActivityListItem<T extends Activity> extends StatelessWidget {
  ActivityListItem({Key? key, required this.activity, required this.gradient})
      : super(key: key);

  final T activity;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: SizedBox(
          height: 64,
          child: Material(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: activity.category.color.shade300,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              splashColor: activity.category.color.shade200,
              onDoubleTap: () {
                log('Double tap');
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.reorder),
                  ),
                  Expanded(
                      child: Text(activity.name,
                          style: theme.textTheme.subtitle1)),
                  IconButton(
                    icon: Icon(Icons.radio_button_unchecked),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    onPressed: () {
                      log('Complete activity');
                      showDialog(
                          context: context,
                          builder: (context) => MoodRater(activity: activity));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MoodRater extends StatefulWidget {
  const MoodRater({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  State<MoodRater> createState() => _MoodRaterState();
}

class _MoodRaterState extends State<MoodRater> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      title: Column(
        children: [
          Text('Track Activity'),
          SizedBox(height: 12),
          Text(widget.activity.name,
              style: theme.textTheme.subtitle1!
                  .copyWith(color: widget.activity.category.color.shade800))
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          for (var mood in Mood.moods.values)
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  log(mood.name);
                },
                icon: Icon(mood.iconData, size: 50))
        ]),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
      ],
    );
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
    return Scrollbar(
      isAlwaysShown: true,
      child: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

                /// TODO make gradient follow dragged list item
                colors: [Colors.blue, Colors.red],
              ),
            ),
            child: Container(),
          ),
          Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.transparent,
                shadowColor: Colors.transparent),
            child: ReorderableListView.builder(
                restorationId: 'activitiesList',
                onReorder: (oldIndex, newIndex) {
                  final replace = _activities.removeAt(oldIndex);
                  if (oldIndex > newIndex) {
                    _activities.insert(math.max(0, newIndex), replace);
                  } else {
                    _activities.insert(newIndex - 1, replace);
                  }
                },
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  final activity = _activities[index];
                  final Color thisColor = activity.category.color.shade100;
                  final Color? lastColor = (index - 1 >= 0)
                      ? _activities[index - 1].category.color.shade100
                      : null;
                  final Color? nextColor = (index + 1 < _activities.length)
                      ? _activities[index + 1].category.color.shade100
                      : null;
                  LinearGradient gradient;

                  if (index == 0) {
                    if (_activities.length == 1) {
                      gradient = LinearGradient(colors: [thisColor]);
                    } else {
                      gradient = LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            thisColor,
                            Color.lerp(thisColor, nextColor, 0.5)!
                          ]);
                    }
                  } else if (index == _activities.length - 1) {
                    gradient = LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.lerp(lastColor, thisColor, 0.5)!,
                          thisColor,
                        ]);
                  } else {
                    gradient = LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.lerp(lastColor, thisColor, 0.5)!,
                          thisColor,
                          Color.lerp(thisColor, nextColor, 0.5)!,
                        ]);
                  }

                  return ActivityListItem(
                      key: ValueKey(index),
                      activity: activity,
                      gradient: gradient);
                }),
          ),
        ],
      ),
    );
  }
}
