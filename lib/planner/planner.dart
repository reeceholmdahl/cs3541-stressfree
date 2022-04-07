import 'dart:developer';

import 'package:firstapp/drawer.dart';
import 'package:firstapp/planner/constants.dart';
import 'package:firstapp/data/planned_activity.dart';
import 'package:firstapp/planner/planner_settings.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
  ActivityListItem({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final T activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: activity.category.color.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: SizedBox(
          height: 64,
          child: Material(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: activity.category.color.shade400,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              splashColor: activity.category.color.shade300,
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
                          builder: (context) => AlertDialog(
                                title: Column(
                                  children: [
                                    Text('Track Activity'),
                                    SizedBox(height: 12),
                                    Text(activity.name,
                                        style: theme.textTheme.subtitle1!
                                            .copyWith(
                                                color: activity
                                                    .category.color.shade800))
                                  ],
                                ),
                                content: Text(activity.name +
                                    '\n' +
                                    activity.category.name),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('CANCEL'),
                                  ),
                                ],
                              ));
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
                  _activities.insert(math.max(0, newIndex - 1), replace);
                },
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  final activity = _activities[index];
                  return ActivityListItem(
                      key: ValueKey(index), activity: activity);
                }),
          ),
        ],
      ),
    );
  }
}
