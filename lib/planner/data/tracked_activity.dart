import 'package:firstapp/mood.dart';
import 'package:firstapp/planner/data/planned_activity.dart';

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
