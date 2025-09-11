import 'package:flutter/material.dart';

class selectDatetime {
  static Future<DateTime?> selectDate(BuildContext context) async {
    DateTime _selectedDate = DateTime.now();
    TimeOfDay _selectedTime = TimeOfDay.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _selectedTime = await selectTime(context, _selectedTime);
    }
    DateTime mergedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    var obj = mergedDateTime;
    return obj;
  }

  static Future<TimeOfDay> selectTime(BuildContext context, TimeOfDay _selectedTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      _selectedTime = picked;
    }
    return _selectedTime;
  }
}
