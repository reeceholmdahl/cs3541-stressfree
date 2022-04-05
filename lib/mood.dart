import 'package:flutter/material.dart';

/// Immutable object once created
class Mood {
  final String name;
  final MaterialColor color;
  final Image icon;

  const Mood(this.name, this.color, this.icon);

  /// Moods for now, subject to change.
  /// Using a map for data types like this so they can be referenced back by just their name
  static final moods = {
    'bad': Mood('Bad', Colors.red, Image.asset('assets/icon-bad.png')),
    'medium':
        Mood('Medium', Colors.amber, Image.asset('assets/icon-medium.png')),
    'good': Mood('Good', Colors.lime, Image.asset('assets/icon-good.png')),
    'great': Mood('Great', Colors.green, Image.asset('assets/icon-great.png'))
  };

  /// Null object design pattern
  static final nullMood =
      Mood('Null', Colors.brown, Image.asset('assets/transparent_file'));
}
