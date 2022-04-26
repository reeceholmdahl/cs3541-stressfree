import 'activity.dart';
import 'mood.dart';
import 'planned_activity.dart';

class TrackedActivity extends Activity {
  final PlannedActivity activity;
  final Mood mood;

  TrackedActivity(this.activity, this.mood)
      : super(activity.name, activity.category);
}
