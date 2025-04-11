import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/doctor_appointment_model.dart';
import '../../../core/object_box.dart';

class AppointmentController extends GetxController {
  late final ObjectBox objectBox;
  var appointments = <DoctorAppointment>[].obs;
  var isLoading = false.obs;
  var isStoreInitialized = false.obs;
  var initializationError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeStore();
  }

  Future<void> _initializeStore() async {
    try {
      isLoading(true);
      initializationError.value = '';
      objectBox = await ObjectBox.create();  // Use the singleton
      isStoreInitialized(true);
      await loadAppointments();
      debugPrint("ObjectBox initialized successfully");
    } catch (e) {
      debugPrint("Error initializing ObjectBox: ${e.toString()}");
      initializationError.value = e.toString();
      isStoreInitialized(false);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadAppointments() async {
    if (!isStoreInitialized.value) return;

    try {
      isLoading(true);
      final allAppointments = objectBox.doctorAppointmentBox.getAll();
      appointments.assignAll(allAppointments);
      debugPrint("Loaded ${allAppointments.length} appointments");
    } catch (e) {
      debugPrint("Error loading appointments: ${e.toString()}");
      showError("Failed to load appointments");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addAppointment(DoctorAppointment appointment) async {
    if (!isStoreInitialized.value) {
      showError("Database not initialized");
      return;
    }

    try {
      isLoading(true);
      final id = objectBox.doctorAppointmentBox.put(appointment);
      debugPrint("Appointment saved with ID: $id");
      await loadAppointments();
      Get.back(); // Close the add appointment screen
      showSuccess("Appointment Added");
    } catch (e) {
      debugPrint("Error adding appointment: ${e.toString()}");
      showError("Failed to add appointment");
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteAppointment(int id) async {
    if (!isStoreInitialized.value) return;

    try {
      isLoading(true);
      final success = objectBox.doctorAppointmentBox.remove(id);
      debugPrint("Appointment deleted: $success");
      await loadAppointments();
      showSuccess("Appointment Deleted");
    } catch (e) {
      debugPrint("Error deleting appointment: ${e.toString()}");
      showError("Failed to delete appointment");
    } finally {
      isLoading(false);
    }
  }

  Future<void> retryInitialization() async {
    await _initializeStore();
  }

  void showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void showSuccess(String message) {
    Get.snackbar(
      "Success",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    objectBox.close();
    super.onClose();
  }
}
