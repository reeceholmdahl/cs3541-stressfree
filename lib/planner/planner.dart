import 'dart:developer';

import 'package:firstapp/planner/constants.dart';
import 'package:firstapp/planner/custom_icon_button.dart';
import 'package:flutter/material.dart';

import 'package:firstapp/drawer.dart';
import 'package:firstapp/data/mood.dart';
import 'package:firstapp/data/activity_category.dart';
import 'package:firstapp/data/planned_activity.dart';
import 'package:firstapp/data/tracked_activity.dart';

import 'planner_settings.dart';
import 'expandable_fab.dart';

class PlannerMediator {
  final List<Activity> activities = [];
  final notifier = BasicNotifier();

  dynamic _sender;

  void notify(sender) {
    _sender = sender;

    log('notify: ' + sender.runtimeType.toString());

    if (sender is ActivityAdder) {
      log('notify: _onAddActivity');
      _onAddActivity();
    } else if (sender is ActivityRemover) {
      log('notify: _onRemoveActivity');
      _onRemoveActivity();
    } else if (sender is MoodTracker) {
      log('notify: _onTrackActivity');
      _onTrackActivity();
    } else if (sender is ActivityReorderer) {
      log('notify: _onReorderActivity');
      _onReorderActivity();
    }
  }

  void _onAddActivity() {
    assert(_sender is ActivityAdder);

    final sender = _sender as ActivityAdder;
    activities.insert(0, sender.activity);

    notifier.notify();
  }

  void _onRemoveActivity() {
    assert(_sender is ActivityRemover);

    final sender = _sender as ActivityRemover;
    activities.removeAt(sender.index);

    notifier.notify();
  }

  void _onTrackActivity() {
    assert(_sender is MoodTracker);

    final sender = _sender as MoodTracker;

    assert(activities[sender.index] is PlannedActivity);

    activities.insert(
        sender.index,
        new TrackedActivity(
            activities[sender.index] as PlannedActivity, sender.mood));

    activities.removeAt(sender.index + 1);

    notifier.notify();
  }

  void _onReorderActivity() {
    assert(_sender is ActivityReorderer);

    final sender = _sender as ActivityReorderer;

    int newIndex = sender.newIndex;
    if (sender.oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Activity activity = activities.removeAt(sender.oldIndex);
    activities.insert(newIndex, activity);
  }
}

class ActivityAdder {
  final Activity activity;

  ActivityAdder({required PlannerMediator mediator, required this.activity}) {
    mediator.notify(this);
  }
}

class ActivityRemover {
  final int index;

  ActivityRemover({required PlannerMediator mediator, required this.index}) {
    mediator.notify(this);
  }
}

class MoodTracker {
  final int index;
  final Mood mood;

  MoodTracker(
      {required PlannerMediator mediator,
      required this.index,
      required this.mood}) {
    mediator.notify(this);
  }
}

class ActivityReorderer {
  final int oldIndex, newIndex;

  ActivityReorderer(
      {required PlannerMediator mediator,
      required this.oldIndex,
      required this.newIndex}) {
    mediator.notify(this);
  }
}

class BasicNotifier with ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

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
          onPressed: () => closeFabNotifier.notify(),
        ),
        ActionButton(
          icon: Icon(Icons.check_circle_outline),
          color: Colors.green,
          onPressed: () => showDialog<void>(
            context: context,
            builder: (context) {
              return AddActivityDialog<TrackedActivity>(mediator: mediator);
            },
          ),
        ),
        ActionButton(
          icon: Icon(Icons.calendar_month),
          color: Colors.blue,
          onPressed: () => showDialog<void>(
            context: context,
            builder: (context) {
              return AddActivityDialog<PlannedActivity>(mediator: mediator);
            },
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
  MoodRater? moodRater;

  String activityName = '';
  ActivityCategory activityCategory = ActivityCategory.nullCategory;
  bool isPresetActivity = false;

  bool _isActivityValid() => (activityCategory !=
          ActivityCategory.nullCategory &&
      (_formKey.currentState == null || _formKey.currentState!.validate()) &&
      (T == TrackedActivity ? moodRater!.selectedMood != Mood.nullMood : true));

  void _addActivity() {
    var plannedActivity = PlannedActivity(activityName, activityCategory);
    Activity activity = PlannedActivity.nullActivity;

    if (T == PlannedActivity)
      activity = plannedActivity;
    else if (T == TrackedActivity)
      activity = TrackedActivity(plannedActivity, moodRater!.selectedMood);

    ActivityAdder(mediator: widget.mediator, activity: activity);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (moodRater == null) {
      moodRater = MoodRater(onPressed: () => setState(() {}));
    }

    return Form(
      key: _formKey,
      child: AlertDialog(
        content: Container(
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
                        onSelected: (PlannedActivity activity) => setState(() {
                          _textController.text = activityName = activity.name;
                          activityCategory = activity.category;
                          isPresetActivity = true;
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
              ),
              Spacer(flex: 1),
              Flexible(
                flex: 5,
                child: DropdownButtonFormField<ActivityCategory>(
                  value: (activityCategory == ActivityCategory.nullCategory
                      ? null
                      : activityCategory),
                  icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                  iconEnabledColor: Colors.black.withOpacity(0.6),
                  iconDisabledColor: Colors.black.withOpacity(0.3),
                  iconSize: 30,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: activityCategory.color.shade400,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final category in activityCategoriesList)
                      DropdownMenuItem<ActivityCategory>(
                          value: category, child: Text(category.name))
                  ],
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
                Flexible(flex: 5, child: moodRater!)
              ],
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
            child: const Text('ADD'),
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
  late List<Activity> activities;

  ActivityListView({required this.mediator});

  @override
  Widget build(BuildContext context) {
    activities = mediator.activities;

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
              restorationId: 'activitiesList',
              onReorder: (oldIndex, newIndex) => ActivityReorderer(
                  mediator: mediator, oldIndex: oldIndex, newIndex: newIndex),
              itemCount: activities.length,
              itemBuilder: (BuildContext context, int index) {
                final activity = activities[index];

                return ActivityListItem(
                    key: ValueKey(index),
                    index: index,
                    activity: activity,
                    gradient: _makeGradient(index),
                    mediator: mediator);
              },
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _makeGradient(int index) {
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

class ActivityListItemActionIcon extends StatefulWidget {
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

  @override
  State<ActivityListItemActionIcon> createState() =>
      _ActivityListItemActionIconState();
}

class _ActivityListItemActionIconState
    extends State<ActivityListItemActionIcon> {
  bool deleteMode = false;

  void _onLongPress() {
    log('Delete mode!');
    setState(() {
      deleteMode = true;
    });
  }

  void _onDelete() {
    ActivityRemover(mediator: widget.mediator, index: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    var icon = deleteMode
        ? widget.deleteIcon
        : Material(
            elevation: 2,
            shape: CircleBorder(),
            color: (widget.activity is TrackedActivity)
                ? (widget.activity as TrackedActivity).mood.color.shade300
                : widget.activity.category.color.shade300,
            child: (widget.activity is TrackedActivity)
                ? Icon((widget.activity as TrackedActivity).mood.iconData,
                    color: Colors.black.withOpacity(0.7))
                : Icon(Icons.radio_button_unchecked,
                    color: Colors.black.withOpacity(0.7)),
          );

    return CustomIconButton(
      onPressed: deleteMode ? _onDelete : widget.onPressed,
      onLongPress: _onLongPress,
      icon: icon,
      splashColor: widget.activity.category.color.shade200,
    );
  }
}

class MoodRater extends StatefulWidget {
  Mood selectedMood = Mood.nullMood;
  final VoidCallback onPressed;

  MoodRater({required this.onPressed});

  @override
  State<MoodRater> createState() => _MoodRaterState();
}

class _MoodRaterState extends State<MoodRater> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var mood in Mood.moods.values)
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: mood.color.shade300, width: 3),
              color: widget.selectedMood == mood
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
                    widget.selectedMood = mood;
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
                mediator: mediator, index: index, mood: moodRater.selectedMood);
            Navigator.of(context).pop();
          },
          child: const Text('Track'),
        ),
      ],
    );
  }
}
