import 'dart:developer';
import 'dart:math' as math;

import 'package:firstapp/data/activity_category.dart';
import 'package:flutter/material.dart';

import 'package:firstapp/drawer.dart';
import 'package:firstapp/data/planned_activity.dart';
import 'package:firstapp/data/tracked_activity.dart';
import 'package:firstapp/data/mood.dart';

import 'constants.dart';
import 'planner_settings.dart';
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
                  builder: (context) => PlannerSettings(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          // _newPlannedActivity.addListener(() {
          // });

          return ActivityList();
        },
      ),
      floatingActionButton: PlannerFab(),
    );
  }
}

class PlannerFab extends StatelessWidget {
  final _closeFab = _Notifier();

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      distance: 112,
      closeFab: _closeFab,
      children: [
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
            builder: (context) => AddPlannedActivity(),
          ),
        )
      ],
    );
  }
}

class AddPlannedActivity extends StatefulWidget {
  @override
  State<AddPlannedActivity> createState() => _AddPlannedActivityState();
}

class _AddPlannedActivityState extends State<AddPlannedActivity> {
  final _formKey = GlobalKey<FormState>();
  final _text = TextEditingController();
  Activity activity = PlannedActivity.nullActivity;
  bool presetActivity = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        content: SizedBox(
          height: 160,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    TextFormField(
                      controller: _text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(8, 20, 36, 20),
                        labelText: 'Enter an activity',
                        filled: true,
                        fillColor: activity.category.color.shade100,
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? input) {
                        if (input == null || input.isEmpty) {
                          return 'Please name this activity.';
                        } else if (input.length > 22) {
                          return 'Please enter a shorter activity.';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          if (activity.name != value) {
                            presetActivity = false;
                            log('Valid ' +
                                (_formKey.currentState!.validate()).toString());
                          }
                        });
                      },
                      autovalidateMode: AutovalidateMode.always,
                    ),
                    Positioned(
                      right: 0,
                      top: 5,
                      child: PopupMenuButton<PlannedActivity>(
                        icon: Icon(Icons.arrow_drop_down,
                            color: Colors.black.withOpacity(0.7)),
                        iconSize: 30,
                        onSelected: (PlannedActivity activity) => setState(() {
                          _text.text = activity.name;
                          this.activity = activity;
                          presetActivity = true;
                        }),
                        itemBuilder: (context) {
                          return [
                            for (final activity in presetActivitiesList)
                              PopupMenuItem<PlannedActivity>(
                                  value: activity, child: Text(activity.name))
                          ];
                        },
                      ),
                    )
                  ],
                ),
                DropdownButtonFormField<ActivityCategory>(
                  value: (activity.category == ActivityCategory.nullCategory
                      ? null
                      : activity.category),
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  iconEnabledColor: Colors.black.withOpacity(0.6),
                  iconDisabledColor: Colors.black.withOpacity(0.3),
                  iconSize: 30,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: activity.category.color.shade400,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final category in activityCategoriesList)
                      DropdownMenuItem<ActivityCategory>(
                          value: category, child: Text(category.name))
                  ],
                  onChanged: presetActivity
                      ? null
                      : (category) => setState(
                            () {
                              activity =
                                  PlannedActivity(activity.name, category!);
                            },
                          ),
                )
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: (activity != PlannedActivity.nullActivity &&
                    (_formKey.currentState == null ||
                        _formKey.currentState!.validate()))
                ? () {
                    // TODO Add new activity
                    Navigator.of(context).pop();
                  }
                : null,
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _text.dispose();
  }
}

@immutable
class _TrackedPair {
  const _TrackedPair(this.index, this.mood);

  final int index;
  final Mood mood;
}

class ActivityList extends StatefulWidget {
  List<Activity> activities = [
    for (int i = 0; i < 50; ++i) presetActivitiesList[i % 7]
  ];

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  final _trackNotifier =
      ValueNotifier<_TrackedPair>(_TrackedPair(-1, Mood.nullMood));

  @override
  void initState() {
    super.initState();
    _trackNotifier.addListener(() {
      final index = _trackNotifier.value.index;
      final mood = _trackNotifier.value.mood;

      final activity = widget.activities[index] as PlannedActivity;
      final newActivity = TrackedActivity(activity, mood);

      setState(() {
        widget.activities.insert(index, newActivity);
        widget.activities.removeAt(index + 1);
      });
    });
  }

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
                final replace = widget.activities.removeAt(oldIndex);
                if (oldIndex > newIndex) {
                  widget.activities.insert(math.max(0, newIndex), replace);
                } else {
                  widget.activities.insert(newIndex - 1, replace);
                }
              },
              itemCount: widget.activities.length,
              itemBuilder: (context, index) {
                final activity = widget.activities[index];
                final Color thisColor = activity.category.color.shade100;
                final Color? lastColor = (index - 1 >= 0)
                    ? widget.activities[index - 1].category.color.shade100
                    : null;
                final Color? nextColor = (index + 1 < widget.activities.length)
                    ? widget.activities[index + 1].category.color.shade100
                    : null;
                LinearGradient gradient;

                if (index == 0) {
                  if (widget.activities.length == 1) {
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
                } else if (index == widget.activities.length - 1) {
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

                if (activity is TrackedActivity) {
                  log('Tracking works');
                }

                return ActivityListItem(
                  key: ValueKey(index),
                  index: index,
                  activity: activity,
                  gradient: gradient,
                  trackNotifier: _trackNotifier,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _trackNotifier.dispose();
  }
}

class ActivityListItem extends StatelessWidget {
  ActivityListItem(
      {Key? key,
      required this.activity,
      required this.index,
      required this.gradient,
      required this.trackNotifier})
      : super(key: key);

  final Activity activity;
  final int index;
  final Gradient gradient;
  final ValueNotifier trackNotifier;

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
                    child: Icon(
                      Icons.reorder,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  Expanded(
                      child: Text(activity.name,
                          style: theme.textTheme.subtitle1)),
                  if (activity is PlannedActivity)
                    IconButton(
                      splashColor: activity.category.color.shade200,
                      icon: Icon(Icons.radio_button_unchecked,
                          color: Colors.black.withOpacity(0.7)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => MoodRater(
                            activity: activity,
                            index: index,
                            trackNotifier: trackNotifier,
                          ),
                        );
                      },
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Material(
                        shape: CircleBorder(),
                        color:
                            (activity as TrackedActivity).mood.color.shade400,
                        child: Icon(
                          (activity as TrackedActivity).mood.iconData,
                        ),
                      ),
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

@immutable
class MoodRater extends StatefulWidget {
  const MoodRater({
    Key? key,
    required this.activity,
    required this.index,
    required this.trackNotifier,
  }) : super(key: key);

  final Activity activity;
  final int index;
  final ValueNotifier trackNotifier;

  @override
  State<MoodRater> createState() => _MoodRaterState();
}

/// TODO animate color change

class _MoodRaterState extends State<MoodRater> {
  Mood selected = Mood.nullMood;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      title: Column(
        children: [
          Text('Track Activity'),
          SizedBox(height: 12),
          Text(
            widget.activity.name,
            style: theme.textTheme.subtitle1!
                .copyWith(color: widget.activity.category.color.shade800),
          )
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var mood in Mood.moods.values)
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: mood.color.shade400, width: 4),
                  color: selected == mood
                      ? mood.color.shade400
                      : mood.color.shade50,
                ),
                child: Material(
                  shape: CircleBorder(),
                  child: InkWell(
                    splashColor: mood.color.shade300,
                    customBorder: CircleBorder(),
                    onTap: () {
                      log(mood.name);
                      setState(() {
                        selected = mood;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(mood.iconData, size: 40),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.trackNotifier.value = _TrackedPair(widget.index, selected);
          },
          child: const Text('Track'),
        ),
      ],
    );
  }
}
