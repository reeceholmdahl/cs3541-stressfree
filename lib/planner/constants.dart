import 'package:flutter/material.dart';

import 'package:firstapp/data/activity_category.dart';
import 'package:firstapp/data/planned_activity.dart';

// TODO eventually all these these should be moved to the database

final presetActivities = {
  'drank water':
      PlannedActivity('Drank water', activityCategories['self care']!),
  'went outside':
      PlannedActivity('Went outside', activityCategories['recreation']!),
  'did homework':
      PlannedActivity('Did homework', activityCategories['school']!),
  'talked to a friend':
      PlannedActivity('Talked to a friend', activityCategories['social']!),
  'took a shower':
      PlannedActivity('Took a shower', activityCategories['self care']!),
  'brushed my teeth':
      PlannedActivity('Brushed my teeth', activityCategories['self care']!),
  'did the dishes':
      PlannedActivity('Did the dishes', activityCategories['cleaning']!),
  'meditated': PlannedActivity('Meditated', activityCategories['self care']!),
  'did yoga': PlannedActivity('Did yoga', activityCategories['exercise']!),
  'did my daily journal':
      PlannedActivity('Did my daily journal', activityCategories['self care']!)
};

List<PlannedActivity> get presetActivitiesList {
  return presetActivities.entries.map((a) => a.value).toList(growable: false);
}

final activityCategories = {
  'self care': ActivityCategory('Self care', Colors.red),
  'exercise': ActivityCategory('Exercise', Colors.yellow),
  'hobby': ActivityCategory('Hobby', Colors.green),
  'social': ActivityCategory('Social', Colors.blue),
  'job': ActivityCategory('Job', Colors.deepPurple),
  'cleaning': ActivityCategory('Cleaning', Colors.orange),
  'school': ActivityCategory('School', Colors.pink),
  'recreation': ActivityCategory('Recreation', Colors.teal)
};

List<ActivityCategory> get activityCategoriesList {
  return activityCategories.entries.map((c) => c.value).toList(growable: false);
}
