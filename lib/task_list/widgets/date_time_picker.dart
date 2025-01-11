import 'package:flutter/material.dart';

Future<void> showDateTimePicker(BuildContext context, DateTime dueDate,
    Function(DateTime) onDateTimeSelected) async {
  await showDatePicker(
    context: context,
    initialDate: dueDate,
    lastDate: DateTime(2100),
    firstDate: dueDate.isBefore(DateTime.now()) ? dueDate : DateTime.now(),
  ).then((selectedDate) async {
    // After selecting the date, display the time picker.
    if (selectedDate != null) {
      context.mounted == true
          ? await showTimePicker(
              context: context,
              initialTime: dueDate == selectedDate
                  ? TimeOfDay.fromDateTime(dueDate)
                  : const TimeOfDay(hour: 23, minute: 59),
            ).then((selectedTime) {
              // Handle the selected date and time here.
              if (selectedTime != null) {
                DateTime selectedDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                onDateTimeSelected(selectedDateTime);
              }
            })
          : null;
    }
  });
}
