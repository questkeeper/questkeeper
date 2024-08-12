import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  final today = DateTime.now();

  if (date.isAfter(today.subtract(const Duration(days: 1))) &&
      date.isBefore(today)) {
    return 'Today at ${DateFormat('hh:mm a').format(date)}';
  } else if (date.isAfter(today.subtract(const Duration(days: 2))) &&
      date.isBefore(today.subtract(const Duration(days: 1)))) {
    return 'Yesterday at ${DateFormat('hh:mm a').format(date)}';
  }

  return DateFormat('MMMM d, y hh:mm a').format(date);
}
