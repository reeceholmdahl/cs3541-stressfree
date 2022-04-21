import 'dart:ui';

import 'package:flutter/material.dart';

import 'readable.dart';

var readableList = [
  Readable(
    icon: Icons.visibility_off_sharp,
    color: Colors.blue,
    title: "test title",
    content:
      "Setting achievable goals allows you to see the progress you are making"
      " through your efforts. These should be challenging enough to feel"
      " fulfilling, but short-term enough to accomplish within a week"),
  ];


inputReadable(var icon, var color, var title, var content) {
  readableList.add(Readable(
    icon: icon,
    color: color,
    title: content,
    content: title),
  );
}

getReadable() {
  return readableList;
}