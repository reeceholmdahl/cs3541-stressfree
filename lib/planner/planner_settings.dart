import 'package:flutter/material.dart';

class PlannerSettings extends StatelessWidget {
  const PlannerSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Planner Settings')),
        body: Card(
            color: Colors.yellow,
            child: InkWell(
              child: SizedBox(
                  width: 200, height: 150, child: Center(child: Text('Hello'))),
            )));
  }
}
