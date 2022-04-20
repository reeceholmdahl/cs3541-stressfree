import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firstapp/drawer.dart';
import 'package:firstapp/constants.dart';

import 'package:firstapp/model/activity.dart';
import 'package:firstapp/model/activity_category.dart';
import 'package:firstapp/model/mood.dart';
import 'package:firstapp/model/planned_activity.dart';
import 'package:firstapp/model/tracked_activity.dart';
import 'package:firstapp/model/future_activity.dart';
import 'package:intl/intl.dart';

import 'planner_model.dart';
import 'planner_settings.dart';
import 'expandable_fab.dart';
import 'custom_icon_button.dart';

class Planner extends StatefulWidget {
  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  final mediator = PlannerMediator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const sideDrawerLeft(),
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
        animation: mediator.notifier,
        builder: (context, child) {
          return ActivityListView(mediator: mediator);
        },
      ),
      floatingActionButton: PlannerFab(mediator: mediator),
    );
  }
}

class PlannerFab extends StatelessWidget {
  final PlannerMediator mediator;

  PlannerFab({required this.mediator});

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
            builder: (context) =>
                AddActivityDialog<FutureActivity>(mediator: mediator),
          ),
        ),
        ActionButton(
          icon: Icon(Icons.check_circle_outline),
          color: Colors.green,
          onPressed: () => showDialog<void>(
            context: context,
            builder: (context) =>
                AddActivityDialog<TrackedActivity>(mediator: mediator),
          ),
        ),
        ActionButton(
          icon: Icon(Icons.calendar_month),
          color: Colors.blue,
          onPressed: () => showDialog<void>(
            context: context,
            builder: (context) =>
                AddActivityDialog<PlannedActivity>(mediator: mediator),
          ),
        )
      ],
    );
  }
}

class AddActivityDialog<T extends Activity> extends StatefulWidget {
  final PlannerMediator mediator;

  AddActivityDialog({required this.mediator});

  @override
  State<AddActivityDialog<T>> createState() => _AddActivityDialogState<T>();
}

class _AddActivityDialogState<T extends Activity>
    extends State<AddActivityDialog<T>> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  late final MoodRater? moodRater;
  late final FuturePlanner? futurePlanner;

  String activityName = '';
  ActivityCategory activityCategory = ActivityCategories.Null;
  bool isPresetActivity = false;

  bool _isActivityValid() => (activityCategory != ActivityCategories.Null &&
      (_formKey.currentState?.validate() ?? false) &&
      (T == TrackedActivity ? moodRater!.selectedMood() != Moods.Null : true));

  void _addActivity() {
    var plannedActivity = PlannedActivity(activityName, activityCategory);
    Activity activity = PresetActivities.Null;

    if (T == PlannedActivity)
      activity = plannedActivity;
    else if (T == TrackedActivity)
      activity = TrackedActivity(plannedActivity, moodRater!.selectedMood());

    assert(activity != PresetActivities.Null);

    ActivityAdder(mediator: widget.mediator, activity: activity);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (T == TrackedActivity) {
      moodRater = MoodRater(onPressed: () => setState(() {}));
    } else if (T == FutureActivity) {
      futurePlanner = FuturePlanner();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 5,
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: _textController,
                        decoration: InputDecoration(
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
                Spacer(flex: 1),
                Flexible(
                  flex: 5,
                  child: DropdownButtonFormField<ActivityCategory>(
                    value: (activityCategory == ActivityCategories.Null
                        ? null
                        : activityCategory),
                    // icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    iconEnabledColor: Colors.black.withOpacity(0.7),
                    iconDisabledColor: Colors.black.withOpacity(0.3),
                    iconSize: 30,
                    decoration: InputDecoration(
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
                      log(select?.name ?? 'None');
                      if (select == null) {
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
                  Spacer(flex: 1),
                  Flexible(flex: 5, child: moodRater!),
                ] else if (T == FutureActivity) ...[
                  Spacer(flex: 1),
                  Flexible(flex: 5, child: futurePlanner!),
                ]
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
  final PlannerMediator mediator;

  ActivityListView({required this.mediator});

  @override
  Widget build(BuildContext context) {
    final activities = mediator.activities;

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
                colors: [Colors.green.shade400, Colors.blue.shade400],
              ),
            ),
            child: Container(),
          ),
          Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.transparent,
                shadowColor: Colors.transparent),
            child: ReorderableListView.builder(
              /// TODO make restoration stack work
              /// TODO look into proxyDecorator
              restorationId: 'activitiesList',
              onReorder: (oldIndex, newIndex) => ActivityReorderer(
                  mediator: mediator, oldIndex: oldIndex, newIndex: newIndex),
              itemCount: activities.length,
              dragStartBehavior: DragStartBehavior.down,
              itemBuilder: (BuildContext context, int index) {
                final activity = activities[index];

                return ActivityListItem(
                    key: ValueKey(index),
                    index: index,
                    activity: activity,
                    gradient: _makeGradient(index, activities),
                    mediator: mediator);
              },
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _makeGradient(int index, List<Activity> activities) {
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
      required this.gradient,
      required this.mediator})
      : super(key: key);

  final Activity activity;
  final int index;
  final Gradient gradient;
  final PlannerMediator mediator;

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
              onDoubleTap: () {},
              onTap: () {
                PlannerStateChanger(
                    mediator: mediator, state: PlannerState(deleteMode: false));
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
                      mediator: mediator,
                      activity: activity,
                      index: index,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => MoodRaterDialog(
                            activity: activity,
                            index: index,
                            mediator: mediator,
                          ),
                        );
                      },
                    )
                  else
                    ActivityListItemActionIcon(
                        mediator: mediator,
                        onPressed: null,
                        activity: activity,
                        index: index),
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
  final PlannerMediator mediator;
  final VoidCallback? onPressed;
  final Activity activity;
  final int index;

  final deleteIcon = Icon(Icons.delete, color: Colors.black.withOpacity(0.7));

  ActivityListItemActionIcon(
      {required this.mediator,
      required this.onPressed,
      required this.activity,
      required this.index});

  void _onLongPress() {
    PlannerStateChanger(
        mediator: mediator, state: PlannerState(deleteMode: true));
  }

  void _onDelete() {
    ActivityRemover(mediator: mediator, index: index);
    PlannerStateChanger(
        mediator: mediator, state: PlannerState(deleteMode: false));
  }

  @override
  Widget build(BuildContext context) {
    final icon = mediator.state.deleteMode
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
      onPressed: mediator.state.deleteMode ? _onDelete : onPressed,
      onLongPress: _onLongPress,
      icon: icon,
      splashColor: activity.category.color.shade200,
    );
  }
}

class MoodRater extends StatefulWidget {
  // Mood selectedMood = Mood.nullMood;
  final _notifier = ValueNotifier<Mood>(Moods.Null);
  final VoidCallback onPressed;

  MoodRater({required this.onPressed});

  Mood selectedMood() => _notifier.value;

  @override
  State<MoodRater> createState() => _MoodRaterState();
}

class _MoodRaterState extends State<MoodRater> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final mood in MoodsList)
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: mood.color.shade300, width: 3),
              color: widget._notifier.value == mood
                  ? mood.color.shade300
                  : mood.color.shade50,
            ),
            child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              child: InkWell(
                splashColor: mood.color.shade200,
                customBorder: CircleBorder(),
                onTap: () {
                  widget.onPressed();
                  setState(() {
                    widget._notifier.value = mood;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(mood.iconData, size: 36),
                ),
              ),
            ),
          )
      ],
    );
  }
}

/// TODO animate color change
class MoodRaterDialog extends StatelessWidget {
  const MoodRaterDialog({
    Key? key,
    required this.activity,
    required this.index,
    required this.mediator,
  }) : super(key: key);

  final Activity activity;
  final int index;
  final PlannerMediator mediator;

  @override
  Widget build(BuildContext context) {
    final moodRater = MoodRater(onPressed: () {});

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
            MoodTracker(
                mediator: mediator,
                index: index,
                mood: moodRater.selectedMood());
            Navigator.of(context).pop();
          },
          child: const Text('Track'),
        ),
      ],
    );
  }
}

class FuturePlanner extends StatefulWidget {
  final String _onDate = 'Does not repeat';

  final String _daily = 'Daily';
  final String _weekly = 'Weekly';
  final String _monthly = 'Monthly';
  final String _yearly = 'Yearly';

  @override
  State<FuturePlanner> createState() => _FuturePlannerState();
}

class _FuturePlannerState extends State<FuturePlanner> {
  String type = '';
  DateTime onDate = DateTime.now().add(Duration(hours: 24));
  DateTime startDate = DateTime.now();
  DateTime? endDate;

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
            });
        },
        child: Text(endDate == null
            ? 'N/A'
            : DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                .format(endDate!)),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 5,
          child: DropdownButtonFormField<String>(
            hint: Text('Choose a recurrence...',
                style: TextStyle(color: Colors.grey.shade600)),
            onChanged: (value) {
              setState(() {
                type = value!;
                endDate = null;
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
          Spacer(flex: 1),
          Builder(builder: (BuildContext context) {
            final columnChildren = <Widget>[];
            if (type == widget._onDate) {
              return makeOnDatePicker(context);
            } else {
              columnChildren.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  makeStartDatePicker(context),
                  makeEndDatePicker(context),
                ],
              ));
            }

            if (type == widget._daily) {
              return Column(
                children: columnChildren,
              );
            } else if (type == widget._weekly) {
            } else if (type == widget._monthly) {
            } else if (type == widget._yearly) {}
            return Container();
          }),
        ]
      ],
    );
  }
}
