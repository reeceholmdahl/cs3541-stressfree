import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:firstapp/model/activity.dart';
import 'package:firstapp/model/mood.dart';
import 'package:firstapp/model/planned_activity.dart';
import 'package:firstapp/model/tracked_activity.dart';

@immutable
class PlannerState {
  const PlannerState({required this.deleteMode});

  final bool deleteMode;
}

class PlannerMediator {
  final notifier = BasicNotifier();
  final List<Activity> _activities = [];
  PlannerState _state = const PlannerState(deleteMode: false);
  dynamic _sender;

  List<Activity> get activities {
    return _activities.toList(growable: false);
  }

  PlannerState get state {
    return _state;
  }

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
    } else if (sender is PlannerStateChanger) {
      log('notify: _onStateChange');
      _onStateChange();
    }

    notifier.notify();
  }

  void _onAddActivity() {
    assert(_sender is ActivityAdder);

    final sender = _sender as ActivityAdder;
    _activities.insert(0, sender.activity);
  }

  void _onRemoveActivity() {
    assert(_sender is ActivityRemover);

    final sender = _sender as ActivityRemover;
    _activities.removeAt(sender.index);
  }

  void _onTrackActivity() {
    assert(_sender is MoodTracker);

    final sender = _sender as MoodTracker;

    assert(_activities[sender.index] is PlannedActivity);

    _activities.insert(
        sender.index,
        new TrackedActivity(
            _activities[sender.index] as PlannedActivity, sender.mood));

    _activities.removeAt(sender.index + 1);
  }

  void _onReorderActivity() {
    assert(_sender is ActivityReorderer);

    final sender = _sender as ActivityReorderer;

    int newIndex = sender.newIndex;
    if (sender.oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Activity activity = _activities.removeAt(sender.oldIndex);
    _activities.insert(newIndex, activity);
  }

  void _onStateChange() {
    assert(_sender is PlannerStateChanger);

    final sender = _sender as PlannerStateChanger;

    _state = sender.state;
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

class PlannerStateChanger {
  final PlannerState state;

  PlannerStateChanger(
      {required PlannerMediator mediator, required this.state}) {
    mediator.notify(this);
  }
}

class BasicNotifier with ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
