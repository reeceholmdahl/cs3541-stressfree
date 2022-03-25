
import 'package:flutter/cupertino.dart';

import '../planner.dart';

class clickDirector extends StatelessWidget {
  const clickDirector({
    required this.id,
    required this.name,
    required this.color,
    Key? key,
  }) : super(key: key);

  final int id;
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (this.id == 2) {
      return Planner();
    } else {
      throw UnimplementedError();
    }
  }
}
