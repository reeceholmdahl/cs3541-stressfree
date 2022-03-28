import 'package:firstapp/youtubeStress.dart';
import 'package:flutter/material.dart';

import '../drawer.dart';
import 'homeTab.dart';

class homePage extends StatelessWidget {
  const homePage({Key? key}) : super(key: key);

  static const appTitle = 'Stress Free';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stress Free',
      home: MyHomePage()
    );
  }
}

class MyHomePage extends StatelessWidget {

  Widget buildHomePage(BuildContext context) {
    return homeTab(
      sideDrawer: sideDrawerLeft(),
    );
  }

  @override
  Widget build(context) {
    return buildHomePage(context);
  }
}




