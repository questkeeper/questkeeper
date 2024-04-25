import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  date = date.toLocal();
  return DateFormat('MMMM d, y hh:mm a').format(date);
}
