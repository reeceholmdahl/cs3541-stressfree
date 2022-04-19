import 'package:flutter/foundation.dart';

import 'activity_category.dart';

@immutable
abstract class Activity {
  final String name;
  final ActivityCategory category;

  const Activity(this.name, this.category);
}
