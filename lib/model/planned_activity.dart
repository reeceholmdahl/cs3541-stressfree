import 'package:flutter/foundation.dart';
import 'activity.dart';
import 'activity_category.dart';

@immutable
class PlannedActivity extends Activity {
  final String name;
  final ActivityCategory category;

  const PlannedActivity(this.name, this.category);
}
