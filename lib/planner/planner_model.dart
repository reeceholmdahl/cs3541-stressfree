import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:firstapp/model/activity.dart';
import 'package:firstapp/model/mood.dart';
import 'package:firstapp/model/planned_activity.dart';
import 'package:firstapp/model/tracked_activity.dart';

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
