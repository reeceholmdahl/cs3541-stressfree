import 'package:flutter/material.dart';

import 'package:firstapp/model/activity_category.dart';
import 'package:firstapp/model/planned_activity.dart';

import 'model/activity.dart';
import 'model/mood.dart';

// TODO eventually all these these should be moved to the database as the user can add their own custom presets and categories

const _nullName = "Null";
const _nullColor = Colors.grey;

@immutable
class _NullActivityCategoryType extends ActivityCategory {
  const _NullActivityCategoryType() : super(_nullName, _nullColor);
}

const _NullActivityCategory = const _NullActivityCategoryType();
const _SelfCare = const ActivityCategory('Self care', Colors.red);
const _Exercise = const ActivityCategory('Exercise', Colors.yellow);
const _Hobby = const ActivityCategory('Hobby', Colors.green);
const _Social = const ActivityCategory('Social', Colors.blue);
const _Job = const ActivityCategory('Job', Colors.deepPurple);
const _Cleaning = const ActivityCategory('Cleaning', Colors.orange);
const _School = const ActivityCategory('School', Colors.pink);
const _Recreation = const ActivityCategory('Recreation', Colors.teal);

@immutable
class _ActivityCategoriesType {
  const _ActivityCategoriesType();

  final Null = _NullActivityCategory;
  final SelfCare = _SelfCare;
  final Exercise = _Exercise;
  final Hobby = _Hobby;
  final Social = _Social;
  final Job = _Job;
  final Cleaning = _Cleaning;
  final School = _School;
  final Recreation = _Recreation;
}

const ActivityCategories = const _ActivityCategoriesType();

const List<ActivityCategory> ActivityCategoriesList = const [
  _SelfCare,
  _Exercise,
  _Hobby,
  _Social,
  _Job,
  _Cleaning,
  _School,
  _Recreation,
];

@immutable
class _NullActivityType extends Activity {
  const _NullActivityType() : super(_nullName, _NullActivityCategory);
}

const _NullActivity = const _NullActivityType();
const _DrankWater = const PlannedActivity('Drank water', _SelfCare);
const _WentOutside = const PlannedActivity('Went outside', _Recreation);
const _DidHomework = const PlannedActivity('Did homework', _School);
const _TalkedToAFriend = const PlannedActivity('Talked to a friend', _Social);
const _TookAShower = const PlannedActivity('Took a shower', _SelfCare);
const _BrushedMyTeeth = const PlannedActivity('Brushed my teeth', _SelfCare);
const _DidTheDishes = const PlannedActivity('Did the dishes', _Cleaning);
const _Meditated = const PlannedActivity('Meditated', _SelfCare);
const _DidYoga = const PlannedActivity('Did yoga', _Exercise);
const _DidMyDailyJournal =
    const PlannedActivity('Did my daily journal', _SelfCare);

@immutable
class _PresetActivitiesType {
  const _PresetActivitiesType();

  final Null = _NullActivity;
  final DrankWater = _DrankWater;
  final WentOutside = _WentOutside;
  final DidHomework = _DidHomework;
  final TalkedToAFriend = _TalkedToAFriend;
  final TookAShower = _TookAShower;
  final BrushedMyTeeth = _BrushedMyTeeth;
  final DidTheDishes = _DidTheDishes;
  final Meditated = _Meditated;
  final DidYoga = _DidYoga;
  final DidMyDailyJournal = _DidMyDailyJournal;
}

const PresetActivities = const _PresetActivitiesType();

const List<PlannedActivity> PresetActivitiesList = const [
  _DrankWater,
  _WentOutside,
  _DidHomework,
  _TalkedToAFriend,
  _TookAShower,
  _BrushedMyTeeth,
  _DidTheDishes,
  _Meditated,
  _DidYoga,
  _DidMyDailyJournal,
];

const String _IconFontFamily = 'icomoon';
const IconData _IconBad = IconData(0xe900, fontFamily: _IconFontFamily);
const IconData _IconMedium = IconData(0xe901, fontFamily: _IconFontFamily);
const IconData _IconGood = IconData(0xe902, fontFamily: _IconFontFamily);
const IconData _IconGreat = IconData(0xe903, fontFamily: _IconFontFamily);

const _NullMood =
    const Mood(_nullName, Colors.grey, Icons.do_not_disturb_on_total_silence);
const _Bad = const Mood('Bad', Colors.red, _IconBad);
const _Medium = const Mood('Medium', Colors.amber, _IconMedium);
const _Good = const Mood('Good', Colors.lime, _IconGood);
const _Great = const Mood('Great', Colors.green, _IconGreat);

@immutable
class _MoodsType {
  const _MoodsType();

  final Null = _NullMood;
  final Bad = _Bad;
  final Medium = _Medium;
  final Good = _Good;
  final Great = _Great;
}

const Moods = const _MoodsType();

const List<Mood> MoodsList = const [
  _Bad,
  _Medium,
  _Good,
  _Great,
];
