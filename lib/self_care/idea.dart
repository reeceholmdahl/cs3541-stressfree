import 'package:flutter/material.dart';

class Idea {
  late String what;
  late int type;
  late bool isFavorited;
  late Color iconColor;
  late Color? backgroundColor;
  late IconData? icon;

  Idea(String what, int type) {
    this.what = what;
    this.type = type;
    this.isFavorited = false;
    assignAvatarProperties();
  }

  void switchFavorited() {
    isFavorited = !isFavorited;
  }

  String toString() {
    return what;
  }

  void assignAvatarProperties() {
    switch (type) {
      case 1:
        iconColor = Colors.red;
        backgroundColor = Colors.red[100];
        icon = Icons.api;
        break;
      case 2:
        iconColor = Colors.amber;
        backgroundColor = Colors.yellow[100];
        icon = Icons.accessibility;
        break;
      case 3:
        iconColor = Colors.green;
        backgroundColor = Colors.green[100];
        icon = Icons.wb_sunny_sharp;
        break;
      case 4:
        iconColor = Colors.blue;
        backgroundColor = Colors.blue[100];
        icon = Icons.wc;
        break;
      case 5:
        iconColor = Colors.orange;
        backgroundColor = Colors.orange[100];
        icon = Icons.all_inbox;
        break;
      case 6:
        iconColor = Colors.teal;
        backgroundColor = Colors.teal[100];
        icon = Icons.anchor;
        break;
      default:
        iconColor = Colors.white;
        backgroundColor = Colors.white;
        icon = Icons.add_circle_outlined;
        break;
    }
  }
}
