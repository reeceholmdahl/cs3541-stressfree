import 'package:firstapp/model/readable.dart';
import 'package:flutter/material.dart';

final List<Readable> _readableList = [];

inputReadable(
    IconData icon, MaterialColor color, String title, String content) {
  _readableList.add(
    Readable(icon: icon, color: color, title: content, content: title),
  );
}

getReadables() {
  return _readableList;
}
