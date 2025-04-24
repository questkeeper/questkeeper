import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  date = date.toLocal();
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

String formatDateDifference(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays < 30) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }
}
