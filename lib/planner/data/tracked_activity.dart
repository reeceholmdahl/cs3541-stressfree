import 'package:firstapp/mood.dart';
import 'package:firstapp/planner/data/planned_activity.dart';

class TrackedActivity {
  final PlannedActivity activity;
  final Mood mood;

  const TrackedActivity(this.activity, this.mood);

  static final nullActivity =
      TrackedActivity(PlannedActivity.nullActivity, Mood.nullMood);
}
