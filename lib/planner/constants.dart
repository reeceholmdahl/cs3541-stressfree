import 'package:flutter/material.dart';

import 'data/activity_category.dart';
import 'data/planned_activity.dart';

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

get presetActivitiesList {
  return presetActivities.entries.map((a) => a.value).toList(growable: false);
}

final activityCategories = {
  'self care': ActivityCategory('self care', Colors.red),
  'exercise': ActivityCategory('exercise', Colors.yellow),
  'hobby': ActivityCategory('hobby', Colors.green),
  'social': ActivityCategory('social', Colors.blue),
  'job': ActivityCategory('job', Colors.deepPurple),
  'cleaning': ActivityCategory('cleaning', Colors.orange),
  'school': ActivityCategory('school', Colors.pink),
  'recreation': ActivityCategory('recreation', Colors.teal)
};
