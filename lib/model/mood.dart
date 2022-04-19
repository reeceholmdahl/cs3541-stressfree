import 'package:flutter/material.dart';

@immutable
class Mood {
  final String name;
  final MaterialColor color;
  final IconData iconData;

  const Mood(this.name, this.color, this.iconData);
}
