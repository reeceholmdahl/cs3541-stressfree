import 'dart:developer';

import 'package:firstapp/model/future_activity.dart';
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

class _PlannerMediator {
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

    final activity = _activities[sender.index];
    if (activity is FutureActivity) {
      activity.isHidden = true;
    } else {
      _activities.removeAt(sender.index);
    }
  }

  void _onTrackActivity() {
    assert(_sender is MoodTracker);

    final sender = _sender as MoodTracker;

    final activity = _activities[sender.index];

    if (activity is PlannedActivity) {
      _activities.insert(
          sender.index, new TrackedActivity(activity, sender.mood));
      _activities.removeAt(sender.index + 1);
    } else if (activity is FutureActivity) {
      _activities.insert(
          sender.index, new TrackedActivity(activity, sender.mood));
      activity.isHidden = true;
    } else {
      // ! Can't be here
      assert(false);
    }
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

final PlannerMediator = _PlannerMediator();

class ActivityAdder {
  final Activity activity;

  ActivityAdder(this.activity) {
    PlannerMediator.notify(this);
  }
}

class ActivityRemover {
  final int index;

  ActivityRemover(this.index) {
    PlannerMediator.notify(this);
  }
}

class MoodTracker {
  final int index;
  final Mood mood;

  MoodTracker({required this.index, required this.mood}) {
    PlannerMediator.notify(this);
  }
}

class ActivityReorderer {
  final int oldIndex, newIndex;

  ActivityReorderer({required this.oldIndex, required this.newIndex}) {
    PlannerMediator.notify(this);
  }
}

class PlannerStateChanger {
  final PlannerState state;

  PlannerStateChanger(this.state) {
    PlannerMediator.notify(this);
  }
}

class BasicNotifier with ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
