enum TimeOfDayType { day, dusk, night }

extension DatetimeExtensions on DateTime {
  String getTimeOfDayType() {
    final hour = this.hour;
    late final TimeOfDayType type;
    if (hour >= 3 && hour < 6) {
      type = TimeOfDayType.dusk;
    } else if (hour >= 6 && hour < 16) {
      type = TimeOfDayType.day;
    } else if (hour >= 16 && hour < 19) {
      type = TimeOfDayType.dusk;
    } else {
      type = TimeOfDayType.night;
    }

    return type.toString().split(".").last;
  }
}
