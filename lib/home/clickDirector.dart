import 'package:flutter/cupertino.dart';

import '../main.dart';
import 'home.dart';
import '../planner/planner.dart';

class clickDirector extends StatelessWidget {
  const clickDirector({
    required this.id,
    Key? key,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    if (this.id == 0) {
      return homePage(); //remove these and just replace with your class
    } else if (this.id == 1) {
      return MyApp(); //remove these and just replace with your class
    } else if (this.id == 2) {
      return Planner(); //remove these and just replace with your class
    } else {
      throw UnimplementedError();
    }
  }
}
