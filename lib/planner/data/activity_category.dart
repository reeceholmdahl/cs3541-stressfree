import 'package:flutter/material.dart';

class ActivityCategory {
  final String name;
  final MaterialColor color;

  const ActivityCategory(this.name, this.color);

  static final nullCategory = ActivityCategory('Null', Colors.grey);
}
