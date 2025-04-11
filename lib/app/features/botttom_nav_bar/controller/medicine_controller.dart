// controllers/medicine_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/medicine_model.dart';
import '../../models/medicine_history_model.dart'; // We'll create this

class MedicineController extends GetxController {
  final medicines = <Medicine>[].obs;
  final filteredMedicines = <Medicine>[].obs;
  final searchQuery = ''.obs;
  final history = <MedicineHistory>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMedicines();
    loadHistory();
    ever(searchQuery, (_) => filterMedicines());
  }

  Future<void> loadMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    final medicinesJson = prefs.getString('medicines');
    if (medicinesJson != null) {
      final List<dynamic> decoded = json.decode(medicinesJson);
      medicines.assignAll(decoded.map((m) => Medicine.fromJson(m)).toList());
      filterMedicines();
    }
  }

  Future<void> saveMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    final medicinesJson = json.encode(medicines.map((m) => m.toJson()).toList());
    await prefs.setString('medicines', medicinesJson);
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('medicine_history');
    if (historyJson != null) {
      final List<dynamic> decoded = json.decode(historyJson);
      history.assignAll(decoded.map((h) => MedicineHistory.fromJson(h)).toList());
    }
  }

  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = json.encode(history.map((h) => h.toJson()).toList());
    await prefs.setString('medicine_history', historyJson);
  }

  void addMedicine(Medicine medicine) {
    medicines.add(medicine);
    filterMedicines();
    saveMedicines();
  }

  void updateMedicine(String id, Medicine updatedMedicine) {
    final index = medicines.indexWhere((m) => m.id == id);
    if (index != -1) {
      medicines[index] = updatedMedicine;
      filterMedicines();
      saveMedicines();
    }
  }

  void deleteMedicine(String id) {
    medicines.removeWhere((m) => m.id == id);
    filterMedicines();
    saveMedicines();
  }

  void filterMedicines() {
    if (searchQuery.isEmpty) {
      filteredMedicines.assignAll(medicines);
    } else {
      filteredMedicines.assignAll(medicines.where((medicine) =>
          medicine.name.toLowerCase().contains(searchQuery.toLowerCase())));
    }
  }

  void recordMedicineTaken(Medicine medicine, DateTime date, bool taken) {
    final entry = MedicineHistory(
      medicineId: medicine.id,
      medicineName: medicine.name,
      date: date,
      taken: taken,
      time: TimeOfDay.now(),
    );
    history.add(entry);
    saveHistory();

    if (taken) {
      final index = medicines.indexWhere((m) => m.id == medicine.id);
      if (index != -1) {
        medicines[index] = medicines[index].copyWith(
          currentQuantity: medicines[index].currentQuantity - 1,
        );
        saveMedicines();
      }
    }
  }

  List<MedicineHistory> getHistoryForMedicine(String medicineId) {
    return history.where((h) => h.medicineId == medicineId).toList();
  }

  Map<DateTime, List<MedicineHistory>> getHistoryByDate() {
    final map = <DateTime, List<MedicineHistory>>{};
    for (final entry in history) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (!map.containsKey(date)) {
        map[date] = [];
      }
      map[date]!.add(entry);
    }
    return map;
  }

  List<String> get medicineTypes => [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Drops',
    'Inhaler',
    'Cream',
    'Other'
  ];
}