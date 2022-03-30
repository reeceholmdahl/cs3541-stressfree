import 'package:firstapp/planner/data/activity_category.dart';

class PlannedActivity {
  final String name;
  final ActivityCategory category;

  const PlannedActivity(this.name, this.category);

  static final nullActivity =
      PlannedActivity('Null', ActivityCategory.nullCategory);
}
