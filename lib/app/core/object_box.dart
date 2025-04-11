import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../objectbox.g.dart';
import '../features/models/doctor_appointment_model.dart';
import '../features/models/medical_document_model.dart';

class ObjectBox {
  static Store? _store;
  static Box<DoctorAppointment>? _doctorAppointmentBox;
  static Box<MedicalDocument>? _medicalDocumentBox;

  // Use the static factory method to create the instance
  static Future<ObjectBox> create() async {
    if (_store != null) {
      return ObjectBox._create(_store!); // Return existing instance
    }

    try {
      final docsDir = await getApplicationDocumentsDirectory();
      _store = await openStore(
        directory: p.join(docsDir.path, "obx-medical"),
      );
      debugPrint("ObjectBox database location: ${_store?.directoryPath}");
      return ObjectBox._create(_store!);
    } catch (e, stackTrace) {
      debugPrint("Error creating ObjectBox store: ${e.toString()}");
      debugPrint("Stack trace: $stackTrace");
      rethrow;
    }
  }

  // Private constructor to initialize the ObjectBox instance
  ObjectBox._create(Store store) {
    _doctorAppointmentBox = Box<DoctorAppointment>(store);
    _medicalDocumentBox = Box<MedicalDocument>(store);
    debugPrint("ObjectBox store created with:");
    debugPrint("- DoctorAppointment box: ${_doctorAppointmentBox?.count()} items");
    debugPrint("- MedicalDocument box: ${_medicalDocumentBox?.count()} items");
  }

  Box<DoctorAppointment> get doctorAppointmentBox => _doctorAppointmentBox!;
  Box<MedicalDocument> get medicalDocumentBox => _medicalDocumentBox!;

  Future<void> close() async {
    _store?.close();
    debugPrint("ObjectBox store closed");
  }
}

