import 'package:flutter/material.dart';

import 'constants.dart';
import 'model/mood.dart';

class MoodRater extends StatefulWidget {
  // Mood selectedMood = Mood.nullMood;
  final _notifier = ValueNotifier<Mood>(Moods.Null);
  final VoidCallback onChanged;

  MoodRater({required this.onChanged});

  Mood selectedMood() => _notifier.value;

  @override
  State<MoodRater> createState() => _MoodRaterState();
}

class _MoodRaterState extends State<MoodRater> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final mood in MoodsList)
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: mood.color.shade300, width: 3),
                color: widget._notifier.value == mood
                    ? mood.color.shade300
                    : mood.color.shade50,
              ),
              child: Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                child: InkWell(
                  splashColor: mood.color.shade200,
                  customBorder: CircleBorder(),
                  onTap: () {
                    setState(() {
                      widget._notifier.value = mood;
                    });
                    widget.onChanged();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(mood.iconData, size: 36),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
