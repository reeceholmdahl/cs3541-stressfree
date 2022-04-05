import 'package:firstapp/planner/data/activity_category.dart';

abstract class Activity {
  String get name;
  ActivityCategory get category;

  const Activity();
}

class PlannedActivity extends Activity {
  final String name;
  final ActivityCategory category;

  const PlannedActivity(this.name, this.category);

  static final nullActivity =
      PlannedActivity('Null', ActivityCategory.nullCategory);
}
