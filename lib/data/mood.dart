import 'package:flutter/material.dart';

@immutable
class Mood {
  final String name;
  final MaterialColor color;
  final ImageIcon icon;

  const Mood(this.name, this.color, this.icon);

  /// Moods for now, subject to change.
  /// Using a map for data types like this so they can be referenced back by just their name
  static final moods = {
    'bad':
        Mood('Bad', Colors.red, ImageIcon(AssetImage('assets/icon-bad.png'))),
    'medium': Mood('Medium', Colors.amber,
        ImageIcon(AssetImage('assets/icon-medium.png'))),
    'good': Mood(
        'Good', Colors.lime, ImageIcon(AssetImage('assets/icon-good.png'))),
    'great': Mood(
        'Great', Colors.green, ImageIcon(AssetImage('assets/icon-great.png')))
  };

  /// Null object design pattern
  static final nullMood = Mood(
      'Null', Colors.brown, ImageIcon(AssetImage('assets/transparent_file')));
}
