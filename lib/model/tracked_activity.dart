import 'package:flutter/foundation.dart';
import 'activity.dart';
import 'mood.dart';
import 'planned_activity.dart';

@immutable
class TrackedActivity extends Activity {
  final PlannedActivity activity;
  final Mood mood;

  get name {
    return activity.name;
  }

  get category {
    return activity.category;
  }

  const TrackedActivity(this.activity, this.mood);
}
