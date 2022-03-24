import 'package:flutter/material.dart';

class Planner extends StatelessWidget {
  const Planner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Planner')
        ),
        body: ActivityTracker()
    );
  }
}

class ActivityTracker extends StatefulWidget {
  const ActivityTracker({Key? key}) : super(key: key);

  @override
  State<ActivityTracker> createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends State<ActivityTracker> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0
              ),
              child: TextFormField(
                decoration: const InputDecoration(hintText: 'Add an activity'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }

                  return null;
                },
                onFieldSubmitted: (String? value) {
                  if (_formKey.currentState!.validate()) {
                    // submit
                  }
                },
              )
            ),
          ],
        )
    );
  }
}