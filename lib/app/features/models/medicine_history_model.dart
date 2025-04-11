// models/medicine_history_model.dart
import 'package:flutter/material.dart';

class MedicineHistory {
  final String medicineId;
  final String medicineName;
  final DateTime date;
  final bool taken;
  final TimeOfDay time;

  MedicineHistory({
    required this.medicineId,
    required this.medicineName,
    required this.date,
    required this.taken,
    required this.time,
  });

  factory MedicineHistory.fromJson(Map<String, dynamic> json) {
    return MedicineHistory(
      medicineId: json['medicineId'],
      medicineName: json['medicineName'],
      date: DateTime.parse(json['date']),
      taken: json['taken'],
      time: TimeOfDay(
        hour: json['timeHour'],
        minute: json['timeMinute'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineId': medicineId,
      'medicineName': medicineName,
      'date': date.toIso8601String(),
      'taken': taken,
      'timeHour': time.hour,
      'timeMinute': time.minute,
    };
  }
}