enum TimeOfDayType { morning, dusk, night }

extension DatetimeExtensions on DateTime {
  TimeOfDayType getTimeOfDayType() {
    final hour = this.hour;
    if (hour >= 4 && hour < 6) {
      return TimeOfDayType.dusk;
    } else if (hour >= 6 && hour < 12) {
      return TimeOfDayType.morning;
    } else if (hour >= 15 && hour < 18) {
      return TimeOfDayType.dusk;
    } else {
      return TimeOfDayType.night;
    }
  }
}
