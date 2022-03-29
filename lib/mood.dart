import 'package:flutter/material.dart';

/// Immutable object once created
class Mood {
  final String name;
  final MaterialColor color;

  const Mood(this.name, this.color);

  /// Moods for now, subject to change.
  /// Using a map for data types like this so they can be referenced back by just their name
  static final moods = {
    'bad': Mood('Bad', Colors.red),
    'medium': Mood('Medium', Colors.amber),
    'good': Mood('Good', Colors.lime),
    'great': Mood('Great', Colors.green)
  };

  /// Null object design pattern
  static final nullMood = Mood('Null', Colors.brown);
}
