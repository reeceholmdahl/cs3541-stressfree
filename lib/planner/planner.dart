import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:firstapp/side_drawer.dart';
import 'package:firstapp/mood_rater.dart';
import 'package:firstapp/constants.dart';
import 'package:firstapp/model/activity.dart';
import 'package:firstapp/model/activity_category.dart';
import 'package:firstapp/model/planned_activity.dart';
import 'package:firstapp/model/tracked_activity.dart';
import 'package:firstapp/model/future_activity.dart';

import 'planner_model.dart';
import 'planner_settings.dart';
import 'expandable_fab.dart';
import 'custom_icon_button.dart';

class Planner extends StatefulWidget {
  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
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
      body: AnimatedBuilder(
        animation: PlannerMediator.notifier,
        builder: (context, child) {
          return ActivityListView();
        },
      ),
      floatingActionButton: PlannerFab(),
    );
  }
}

class PlannerFab extends StatelessWidget {
  PlannerFab();

  @override
  Widget build(BuildContext context) {
    final closeFabNotifier = BasicNotifier();

    return ExpandableFab(
      distance: 112,
      closeFab: closeFabNotifier,
      children: [
        ActionButton(
          icon: Icon(Icons.schedule),
          color: Colors.teal,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AddActivityDialog<FutureActivity>(),
          ),
        ),
        ActionButton(
          icon: Icon(Icons.check_circle_outline),
          color: Colors.green,
          onPressed: () => showDialog<void>(
            context: context,
            builder: (context) => AddActivityDialog<TrackedActivity>(),
          ),
        ),
        ActionButton(
          icon: Icon(Icons.calendar_month),
          color: Colors.blue,
          onPressed: () => showDialog<void>(
            context: context,
            builder: (context) => AddActivityDialog<PlannedActivity>(),
          ),
        )
      ],
    );
  }
}

class AddActivityDialog<T extends Activity> extends StatefulWidget {
  AddActivityDialog();

  @override
  State<AddActivityDialog<T>> createState() => _AddActivityDialogState<T>();
}

class _AddActivityDialogState<T extends Activity>
    extends State<AddActivityDialog<T>> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  late final MoodRater? moodRater;
  late final RecurrencePicker? recurrencePicker;

  final databaseRef = FirebaseDatabase.instance.ref('Planner');

  String activityName = '';
  ActivityCategory activityCategory = ActivityCategories.Null;
  bool isPresetActivity = false;

  bool _isActivityValid() =>
      (activityCategory != ActivityCategories.Null &&
          (_formKey.currentState?.validate() ?? false) &&
          (T == TrackedActivity
              ? moodRater!.selectedMood() != Moods.Null
              : true)) &&
      (T == FutureActivity ? recurrencePicker!.recurrence != null : true);

  void _addActivity() {
    var plannedActivity = PlannedActivity(activityName, activityCategory);
    Activity activity = PresetActivities.Null;

    if (T == PlannedActivity)
      activity = plannedActivity;
    else if (T == TrackedActivity)
      activity = TrackedActivity(plannedActivity, moodRater!.selectedMood());
    else if (T == FutureActivity)
      activity = FutureActivity(plannedActivity, recurrencePicker!.recurrence!);

    assert(activity != PresetActivities.Null);

    ActivityAdder(activity);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (T == TrackedActivity) {
      moodRater = MoodRater(onChanged: () => setState(() {}));
    } else if (T == FutureActivity) {
      recurrencePicker = RecurrencePicker(onChanged: () => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 10),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 100,
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: _textController,
                        style: TextStyle(
                            color: isPresetActivity
                                ? Colors.black.withOpacity(0.7)
                                : null,
                            fontWeight:
                                isPresetActivity ? FontWeight.bold : null),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(8, 20, 36, 20),
                          labelText: 'Enter an activity',
                          filled: true,
                          fillColor: activityCategory.color.shade100,
                          border: OutlineInputBorder(),
                        ),
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Give this activity a name';
                          } else if (input.length > 24) {
                            return 'Shorten the activity name';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            if (activityName != value) {
                              isPresetActivity = false;
                              activityName = value;
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
                          onSelected: (PlannedActivity activity) =>
                              setState(() {
                            _textController.text = activityName = activity.name;
                            activityCategory = activity.category;
                            isPresetActivity = true;
                          }),
                          itemBuilder: (context) {
                            return [
                              for (final activity in PresetActivitiesList)
                                PopupMenuItem<PlannedActivity>(
                                    value: activity, child: Text(activity.name))
                            ];
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: DropdownButtonFormField<ActivityCategory>(
                  hint: Text('Choose a category'),
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: isPresetActivity ? FontWeight.bold : null),
                  value: (activityCategory == ActivityCategories.Null
                      ? null
                      : activityCategory),
                  // icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  iconEnabledColor: Colors.black.withOpacity(0.7),
                  iconDisabledColor: Colors.black.withOpacity(0.3),
                  iconSize: 30,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: activityCategory.color.shade400,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final category in ActivityCategoriesList)
                      DropdownMenuItem<ActivityCategory>(
                          value: category, child: Text(category.name))
                  ],
                  validator: (select) {
                    if (select == null &&
                        activityCategory == ActivityCategories.Null) {
                      return 'Select a category';
                    }

                    return null;
                  },
                  onChanged: isPresetActivity
                      ? null
                      : (category) => setState(
                            () {
                              activityCategory = category!;
                            },
                          ),
                ),
              ),
              if (T == TrackedActivity) ...[
                moodRater!,
              ] else if (T == FutureActivity) ...[
                recurrencePicker!,
              ]
            ],
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
            onPressed: _isActivityValid() ? _addActivity : null,
            child: Text((T == FutureActivity) ? 'SCHEDULE' : 'ADD'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}

class ActivityListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activities = PlannerMediator.activities;

    return Scrollbar(
      isAlwaysShown: true,
      child: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent, shadowColor: Colors.transparent),
        child: ReorderableListView(
          /// TODO make restoration stack work
          /// TODO look into proxyDecorator
          restorationId: 'activitiesList',
          onReorder: (oldIndex, newIndex) =>
              ActivityReorderer(oldIndex: oldIndex, newIndex: newIndex),
          dragStartBehavior: DragStartBehavior.down,
          children: [
            for (int i = 0; i < activities.length; ++i)
              if (activities[i] is! FutureActivity ||
                  ((activities[i] as FutureActivity).isToday &&
                      !(activities[i] as FutureActivity).isHidden))
                ActivityListItem(
                  key: ValueKey(i),
                  index: i,
                  activity: activities[i],
                  gradient: _makeGradient(i, activities, context),
                )
          ],
        ),
      ),
    );
  }

  LinearGradient _makeGradient(
      int index, List<Activity> activities, BuildContext context) {
    final activity = activities[index];

    final Color thisColor = activity.category.color.shade100;
    final Color? lastColor =
        (index - 1 >= 0) ? activities[index - 1].category.color.shade100 : null;
    final Color? nextColor = (index + 1 < activities.length)
        ? activities[index + 1].category.color.shade100
        : null;

    LinearGradient gradient;
    if (index == 0) {
      if (activities.length == 1) {
        gradient = LinearGradient(colors: [thisColor, thisColor]);
      } else {
        gradient = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [thisColor, Color.lerp(thisColor, nextColor, 0.5)!]);
      }
    } else if (index == activities.length - 1) {
      gradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(lastColor, thisColor, 0.5)!,
            thisColor,
            Theme.of(context).scaffoldBackgroundColor
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
    return gradient;
  }
}

class ActivityListItem extends StatelessWidget {
  ActivityListItem(
      {Key? key,
      required this.activity,
      required this.index,
      required this.gradient})
      : super(key: key);

  final Activity activity;
  final int index;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      // decoration: BoxDecoration(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: SizedBox(
          height: 64,
          child: Material(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: activity.category.color.shade300,
            child: InkWell(
              onDoubleTap: () {},
              onTap: () {
                PlannerStateChanger(PlannerState(deleteMode: false));
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              splashColor: activity.category.color.shade200,
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
                    ActivityListItemActionIcon(
                      activity: activity,
                      index: index,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => MoodRaterDialog(
                            activity: activity,
                            index: index,
                          ),
                        );
                      },
                    )
                  else
                    ActivityListItemActionIcon(
                        onPressed: null, activity: activity, index: index),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ActivityListItemActionIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  final Activity activity;
  final int index;

  final deleteIcon = Icon(Icons.delete, color: Colors.black.withOpacity(0.7));

  ActivityListItemActionIcon(
      {required this.onPressed, required this.activity, required this.index});

  void _onLongPress() {
    PlannerStateChanger(PlannerState(deleteMode: true));
  }

  void _onDelete() {
    ActivityRemover(index);
    PlannerStateChanger(PlannerState(deleteMode: false));
  }

  @override
  Widget build(BuildContext context) {
    final icon = PlannerMediator.state.deleteMode
        ? deleteIcon
        : Material(
            elevation: 2,
            shape: CircleBorder(),
            color: (activity is TrackedActivity)
                ? (activity as TrackedActivity).mood.color.shade300
                : activity.category.color.shade300,
            child: (activity is TrackedActivity)
                ? Icon((activity as TrackedActivity).mood.iconData,
                    color: Colors.black.withOpacity(0.7))
                : Icon(Icons.radio_button_unchecked,
                    color: Colors.black.withOpacity(0.7)),
          );

    return CustomIconButton(
      onPressed: PlannerMediator.state.deleteMode ? _onDelete : onPressed,
      onLongPress: _onLongPress,
      icon: icon,
      splashColor: activity.category.color.shade200,
    );
  }
}

/// TODO animate color change
class MoodRaterDialog extends StatelessWidget {
  const MoodRaterDialog({
    Key? key,
    required this.activity,
    required this.index,
  }) : super(key: key);

  final Activity activity;
  final int index;

  @override
  Widget build(BuildContext context) {
    final moodRater = MoodRater(onChanged: () {});

    final theme = Theme.of(context);
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      title: Column(
        children: [
          Text('Track Activity'),
          SizedBox(height: 12),
          Text(
            activity.name,
            style: theme.textTheme.subtitle1!
                .copyWith(color: activity.category.color.shade800),
          )
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: moodRater,
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
            MoodTracker(index: index, mood: moodRater.selectedMood());
            Navigator.of(context).pop();
          },
          child: const Text('Track'),
        ),
      ],
    );
  }
}

class RecurrencePicker extends StatefulWidget {
  VoidCallback onChanged;

  RecurrencePicker({required this.onChanged});

  final String _onDate = 'Does not repeat';

  final String _daily = 'Daily';
  final String _weekly = 'Weekly';
  final String _monthly = 'Monthly';
  final String _yearly = 'Yearly';

  Recurrence? recurrence;

  @override
  State<RecurrencePicker> createState() => _RecurrencePickerState();
}

class _RecurrencePickerState extends State<RecurrencePicker> {
  String type = '';
  DateTime onDate = DateTime.now().add(Duration(hours: 24));
  DateTime startDate = DateTime.now();
  DateTime? endDate;

  final List<bool> weekdays = List.generate(7, (i) => false, growable: false);
  final List<String> weekdayNames = const ['M', 'T', 'W', 'Th', 'F', 'Sa', 'S'];

  Widget makeOnDatePicker(BuildContext context) => TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.grey.shade100),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 10,
              child: Text(DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                  .format(onDate)),
            ),
            Spacer(flex: 1),
            const Icon(Icons.calendar_month),
          ],
        ),
        onPressed: () async {
          final tomorrow = DateTime.now().add(Duration(hours: 24));
          final selected = await showDatePicker(
              context: context,
              initialDate: tomorrow,
              firstDate: tomorrow,
              lastDate: tomorrow.add(Duration(hours: 24 * 365)));
          if (selected != null)
            setState(() {
              onDate = selected;
              makeRecurrence();
              widget.onChanged();
            });
        },
      );

  Widget makeStartDatePicker(BuildContext context) => TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.grey.shade100),
        onPressed: () async {
          final now = DateTime.now().add(Duration(hours: 24));
          final selected = await showDatePicker(
              context: context,
              initialDate: now,
              firstDate: now,
              lastDate: now.add(Duration(hours: 24 * 365 * 5)));
          if (selected != null)
            setState(() {
              startDate = selected;
              makeRecurrence();
              widget.onChanged();
            });
        },
        child: Text(DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
            .format(startDate)),
      );

  Widget makeEndDatePicker(BuildContext context) => TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.grey.shade100),
        onLongPress: () => setState(() {
          endDate = null;
        }),
        onPressed: () async {
          final now = DateTime.now().add(Duration(hours: 24));
          final selected = await showDatePicker(
              context: context,
              initialDate: now,
              firstDate: now,
              lastDate: now.add(Duration(hours: 24 * 365 * 5)));
          if (selected != null)
            setState(() {
              endDate = selected;
              makeRecurrence();
              widget.onChanged();
            });
        },
        child: Text(endDate == null
            ? 'N/A'
            : DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                .format(endDate!)),
      );

  void makeRecurrence() {
    if (type == widget._onDate) {
      widget.recurrence = Recurrence.once(date: onDate);
    } else if (type == widget._daily) {
      widget.recurrence =
          Recurrence.daily(startDate: startDate, endDate: endDate);
    } else if (type == widget._weekly) {
      if (!weekdays.reduce((value, element) => value || element)) {
        log('No weekdays selected');
        widget.recurrence = null;
      } else {
        widget.recurrence = Recurrence.weekly(
            startDate: startDate,
            endDate: endDate,
            monday: weekdays[0],
            tuesday: weekdays[1],
            wednesday: weekdays[2],
            thursday: weekdays[3],
            friday: weekdays[4],
            saturday: weekdays[5],
            sunday: weekdays[6]);
      }
    } else if (type == widget._monthly) {
      widget.recurrence =
          Recurrence.monthly(startDate: startDate, endDate: endDate);
    } else if (type == widget._yearly) {
      widget.recurrence =
          Recurrence.yearly(startDate: startDate, endDate: endDate);
    } else {
      widget.recurrence = null;
    }

    log(widget.recurrence.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 80,
          child: DropdownButtonFormField<String>(
            hint: Text('Choose a recurrence...',
                style: TextStyle(color: Colors.grey.shade600)),
            onChanged: (value) {
              setState(() {
                type = value!;
                endDate = null;
                makeRecurrence();
                widget.onChanged();
              });
            },
            iconSize: 30,
            iconEnabledColor: Colors.black.withOpacity(0.7),
            items: [
              widget._onDate,
              widget._daily,
              widget._weekly,
              widget._monthly,
              widget._yearly
            ]
                .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                .toList(),
          ),
        ),
        if (type.isNotEmpty) ...[
          Builder(builder: (BuildContext context) {
            final columnChildren = <Widget>[];
            if (type == widget._onDate) {
              return makeOnDatePicker(context);
            } else {
              columnChildren.add(SizedBox(
                height: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Center(
                            child: Text('Starts on',
                                style: TextStyle(color: Colors.grey.shade700))),
                        makeStartDatePicker(context),
                      ],
                    ),
                    Column(
                      children: [
                        Center(
                            child: Text('Ends on',
                                style: TextStyle(color: Colors.grey.shade700))),
                        makeEndDatePicker(context),
                      ],
                    ),
                  ],
                ),
              ));
            }

            if (type == widget._daily ||
                type == widget._monthly ||
                type == widget._yearly) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: columnChildren,
              );
            } else if (type == widget._weekly) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...columnChildren,
                  SizedBox(
                    height: 25,
                    child: Text(
                      'Days',
                      style: TextStyle(color: Colors.grey.shade700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int i = 0; i < 7; ++i)
                              DecoratedBox(
                                decoration: BoxDecoration(
                                    color: weekdays[i]
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade50,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 2)),
                                child: Material(
                                  shape: CircleBorder(),
                                  color: Colors.transparent,
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: InkWell(
                                        customBorder: CircleBorder(),
                                        onTap: () => setState(() {
                                              weekdays[i] = !weekdays[i];
                                              makeRecurrence();
                                              widget.onChanged();
                                            }),
                                        child: Center(
                                            child: Text(weekdayNames[i]))),
                                  ),
                                ),
                              )
                          ],
                        );
                      },
                    ),
                  )
                ],
              );
            }

            // ! Should be impossible to get here
            throw UnimplementedError();
          }),
        ]
      ],
    );
  }
}
