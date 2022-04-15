import 'package:flutter/foundation.dart';

import 'activity_category.dart';

@immutable
abstract class Activity {
  String get name;
  ActivityCategory get category;

  const Activity();
}

@immutable
class NullActivity extends Activity {
  final String name = "Null";
  final ActivityCategory category = ActivityCategory.nullCategory;
}
