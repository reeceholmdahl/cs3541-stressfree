import 'package:flutter/material.dart';

@immutable
class Mood {
  final String name;
  final MaterialColor color;
  final IconData iconData;

  const Mood(this.name, this.color, this.iconData);

  /// Moods for now, subject to change.
  /// Using a map for data types like this so they can be referenced back by just their name
  static final moods = {
    'bad': Mood('Bad', Colors.red, icon_bad),
    'medium': Mood('Medium', Colors.amber, icon_medium),
    'good': Mood('Good', Colors.lime, icon_good),
    'great': Mood('Great', Colors.green, icon_great)
  };

  /// Null object design pattern
  static final nullMood = Mood('Null', Colors.grey, IconData(0x1));

  static const String _fontFamily = 'icomoon';

  static const IconData icon_bad = IconData(0xe900, fontFamily: _fontFamily);
  static const IconData icon_medium = IconData(0xe901, fontFamily: _fontFamily);
  static const IconData icon_good = IconData(0xe902, fontFamily: _fontFamily);
  static const IconData icon_great = IconData(0xe903, fontFamily: _fontFamily);
}
