import 'package:flutter/material.dart';
import 'package:firstapp/data/mood.dart';
import 'package:firstapp/data/planned_activity.dart';

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

  static final nullActivity =
      TrackedActivity(PlannedActivity.nullActivity, Mood.nullMood);
}
