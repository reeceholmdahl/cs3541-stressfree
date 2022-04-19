import 'package:firstapp/model/planned_activity.dart';

class FutureActivity extends PlannedActivity {
  final DateTime? date;
  final Recurrence? recurrence;

  FutureActivity({required activity, this.date, this.recurrence})
      : super(activity.name, activity.category);
}

class Recurrence {
  final DateTime sourceDate;
  final bool isDaily, isWeekly, isMonthly;
  final List<bool> weeklyDays = List.generate(8, (index) => false);

  Recurrence(
      {required this.sourceDate,
      required this.isDaily,
      required this.isWeekly,
      required this.isMonthly});

  static Recurrence daily(DateTime date) {
    return Recurrence(
        sourceDate: date, isDaily: true, isWeekly: false, isMonthly: false);
  }

  static Recurrence weekly(
    DateTime date, {
    bool everyday = false,
    bool monday = false,
    bool tuesday = false,
    bool wednesday = false,
    bool thursday = false,
    bool friday = false,
    bool saturday = false,
    bool sunday = false,
  }) {
    final r = Recurrence(
        sourceDate: date, isDaily: false, isWeekly: true, isMonthly: false);

    if (everyday) {
      r.weeklyDays.setAll(0, List.generate(8, (index) => false));
    } else {
      if (monday) {
        r.weeklyDays[1] = true;
      }

      if (tuesday) {
        r.weeklyDays[2] = true;
      }

      if (wednesday) {
        r.weeklyDays[3] = true;
      }

      if (thursday) {
        r.weeklyDays[4] = true;
      }

      if (friday) {
        r.weeklyDays[5] = true;
      }

      if (saturday) {
        r.weeklyDays[6] = true;
      }

      if (sunday) {
        r.weeklyDays[7] = true;
      }

      r.weeklyDays[date.weekday] = true;
    }

    return r;
  }

  static Recurrence monthly(DateTime date) {
    return Recurrence(
        sourceDate: date, isDaily: false, isWeekly: false, isMonthly: true);
  }
}

/// Recurrence options:
/// Daily, Weekly, Monthly
/// if Weekly, on Mondays and/or any weekday
