import 'package:firstapp/data/activity_category.dart';
import 'package:flutter/material.dart';

@immutable
abstract class Activity {
  String get name;
  ActivityCategory get category;

  const Activity();
}

@immutable
class PlannedActivity extends Activity {
  final String name;
  final ActivityCategory category;

  const PlannedActivity(this.name, this.category);

  static final nullActivity =
      PlannedActivity('Null', ActivityCategory.nullCategory);
}
