// models/medicine_model.dart
import 'package:flutter/material.dart';

class Medicine {
  final String id;
  final String name;
  final String type;
  final String imagePath;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> reminderTimes;
  final bool notificationsEnabled;
  final int totalQuantity;
  final int currentQuantity;
  final String dosage;
  final String notes;

  Medicine({
    required this.id,
    required this.name,
    required this.type,
    required this.imagePath,
    required this.startDate,
    required this.endDate,
    required this.reminderTimes,
    required this.notificationsEnabled,
    required this.totalQuantity,
    required this.currentQuantity,
    required this.dosage,
    required this.notes,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      imagePath: json['imagePath'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      reminderTimes: List<String>.from(json['reminderTimes']),
      notificationsEnabled: json['notificationsEnabled'],
      totalQuantity: json['totalQuantity'],
      currentQuantity: json['currentQuantity'],
      dosage: json['dosage'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'imagePath': imagePath,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reminderTimes': reminderTimes,
      'notificationsEnabled': notificationsEnabled,
      'totalQuantity': totalQuantity,
      'currentQuantity': currentQuantity,
      'dosage': dosage,
      'notes': notes,
    };
  }

  Medicine copyWith({
    String? id,
    String? name,
    String? type,
    String? imagePath,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? reminderTimes,
    bool? notificationsEnabled,
    int? totalQuantity,
    int? currentQuantity,
    String? dosage,
    String? notes,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      imagePath: imagePath ?? this.imagePath,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      dosage: dosage ?? this.dosage,
      notes: notes ?? this.notes,
    );
  }
}