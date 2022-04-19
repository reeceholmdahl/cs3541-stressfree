import 'package:flutter/material.dart';

@immutable
class ActivityCategory {
  final String name;
  final MaterialColor color;

  const ActivityCategory(this.name, this.color);
}
