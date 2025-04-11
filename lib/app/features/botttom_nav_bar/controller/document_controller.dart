import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/medical_document_model.dart';
import '../../../core/object_box.dart';

class MedicalDocumentController extends GetxController {
  late ObjectBox objectBox;
  var documents = <MedicalDocument>[].obs;
  var isLoading = false.obs;
  var documentTypes = ['Prescription', 'Report', 'Bill', 'Other'].obs;

  @override
  void onInit() async {
    super.onInit();
    objectBox = await ObjectBox.create();
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    try {
      isLoading(true);
      final allDocuments = objectBox.medicalDocumentBox.getAll();
      documents.assignAll(allDocuments);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load documents",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> addDocument(MedicalDocument document) async {
    try {
      isLoading(true);
      objectBox.medicalDocumentBox.put(document);
      await loadDocuments();
      Get.snackbar(
        "Success",
        "Document Added",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add document",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteDocument(int id) async {
    try {
      isLoading(true);
      objectBox.medicalDocumentBox.remove(id);
      await loadDocuments();
      Get.snackbar(
        "Success",
        "Document Deleted",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete document",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}