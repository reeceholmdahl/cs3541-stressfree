import 'package:flutter/foundation.dart';

@immutable
class Technique {
  final String title;
  final String content;

  const Technique({required this.title, required this.content});
}
