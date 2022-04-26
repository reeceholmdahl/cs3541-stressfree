import 'package:flutter/material.dart';

@immutable
class Readable {
  final IconData icon;
  final String title;
  final String content;
  final MaterialColor color;

  const Readable(
      {required this.icon,
      required this.title,
      required this.content,
      required this.color});
}
