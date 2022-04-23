import 'dart:ui';

import 'package:flutter/material.dart';

import 'readable.dart';

var readableList = [

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