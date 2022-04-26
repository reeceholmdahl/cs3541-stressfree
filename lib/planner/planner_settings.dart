import 'package:flutter/material.dart';

class PlannerSettings extends StatelessWidget {
  const PlannerSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planner Settings')),
      body: Center(
        child: Text(
          'Currently unimplemented.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
