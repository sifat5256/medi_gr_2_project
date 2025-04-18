// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'app/features/models/doctor_appointment_model.dart';
import 'app/features/models/medical_document_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 1215921889240355587),
      name: 'MedicalDocument',
      lastPropertyId: const obx_int.IdUid(9, 6883253932410277329),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 5348122685450275629),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 7607902105884255415),
            name: 'title',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 2663295749037376881),
            name: 'date',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 2781259964793830383),
            name: 'filePath',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 7702468891312177703),
            name: 'description',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 3041783762119541207),
            name: 'imagePath',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 6883253932410277329),
            name: 'documentType',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 6279593629144296902),
      name: 'DoctorAppointment',
      lastPropertyId: const obx_int.IdUid(9, 5858433132705072820),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 9222319241299301592),
            name: 'id',
            type: 6,
            flags: 129),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 6578797805969469262),
            name: 'doctorName',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 2798958958831589812),
            name: 'hospitalName',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 9030377073554394023),
            name: 'imageUrl',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 63580573458398139),
            name: 'dateTime',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 4599608073833387978),
            name: 'specialty',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 5858433132705072820),
            name: 'notes',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(2, 6279593629144296902),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        5074082041378270622,
        7195969889192759449,
        1625957866964611139,
        722548088747081203
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    MedicalDocument: obx_int.EntityDefinition<MedicalDocument>(
        model: _entities[0],
        toOneRelations: (MedicalDocument object) => [],
        toManyRelations: (MedicalDocument object) => {},
        getId: (MedicalDocument object) => object.id,
        setId: (MedicalDocument object, int id) {
          object.id = id;
        },
        objectToFB: (MedicalDocument object, fb.Builder fbb) {
          final titleOffset = fbb.writeString(object.title);
          final filePathOffset = fbb.writeString(object.filePath);
          final descriptionOffset = fbb.writeString(object.description);
          final imagePathOffset = object.imagePath == null
              ? null
              : fbb.writeString(object.imagePath!);
          final documentTypeOffset = fbb.writeString(object.documentType);
          fbb.startTable(10);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, titleOffset);
          fbb.addInt64(2, object.date.millisecondsSinceEpoch);
          fbb.addOffset(4, filePathOffset);
          fbb.addOffset(6, descriptionOffset);
          fbb.addOffset(7, imagePathOffset);
          fbb.addOffset(8, documentTypeOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final titleParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final dateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          final imagePathParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 18);
          final filePathParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 12, '');
          final descriptionParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 16, '');
          final documentTypeParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 20, '');
          final object = MedicalDocument(
              id: idParam,
              title: titleParam,
              date: dateParam,
              imagePath: imagePathParam,
              filePath: filePathParam,
              description: descriptionParam,
              documentType: documentTypeParam);

          return object;
        }),
    DoctorAppointment: obx_int.EntityDefinition<DoctorAppointment>(
        model: _entities[1],
        toOneRelations: (DoctorAppointment object) => [],
        toManyRelations: (DoctorAppointment object) => {},
        getId: (DoctorAppointment object) => object.id,
        setId: (DoctorAppointment object, int id) {
          object.id = id;
        },
        objectToFB: (DoctorAppointment object, fb.Builder fbb) {
          final doctorNameOffset = fbb.writeString(object.doctorName);
          final hospitalNameOffset = fbb.writeString(object.hospitalName);
          final imageUrlOffset = fbb.writeString(object.imageUrl);
          final specialtyOffset = fbb.writeString(object.specialty);
          final notesOffset = fbb.writeString(object.notes);
          fbb.startTable(10);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, doctorNameOffset);
          fbb.addOffset(2, hospitalNameOffset);
          fbb.addOffset(5, imageUrlOffset);
          fbb.addInt64(6, object.dateTime.millisecondsSinceEpoch);
          fbb.addOffset(7, specialtyOffset);
          fbb.addOffset(8, notesOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final doctorNameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final hospitalNameParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, '');
          final specialtyParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 18, '');
          final dateTimeParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0));
          final imageUrlParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 14, '');
          final notesParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 20, '');
          final object = DoctorAppointment(
              id: idParam,
              doctorName: doctorNameParam,
              hospitalName: hospitalNameParam,
              specialty: specialtyParam,
              dateTime: dateTimeParam,
              imageUrl: imageUrlParam,
              notes: notesParam);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [MedicalDocument] entity fields to define ObjectBox queries.
class MedicalDocument_ {
  /// see [MedicalDocument.id]
  static final id =
      obx.QueryIntegerProperty<MedicalDocument>(_entities[0].properties[0]);

  /// see [MedicalDocument.title]
  static final title =
      obx.QueryStringProperty<MedicalDocument>(_entities[0].properties[1]);

  /// see [MedicalDocument.date]
  static final date =
      obx.QueryDateProperty<MedicalDocument>(_entities[0].properties[2]);

  /// see [MedicalDocument.filePath]
  static final filePath =
      obx.QueryStringProperty<MedicalDocument>(_entities[0].properties[3]);

  /// see [MedicalDocument.description]
  static final description =
      obx.QueryStringProperty<MedicalDocument>(_entities[0].properties[4]);

  /// see [MedicalDocument.imagePath]
  static final imagePath =
      obx.QueryStringProperty<MedicalDocument>(_entities[0].properties[5]);

  /// see [MedicalDocument.documentType]
  static final documentType =
      obx.QueryStringProperty<MedicalDocument>(_entities[0].properties[6]);
}

/// [DoctorAppointment] entity fields to define ObjectBox queries.
class DoctorAppointment_ {
  /// see [DoctorAppointment.id]
  static final id =
      obx.QueryIntegerProperty<DoctorAppointment>(_entities[1].properties[0]);

  /// see [DoctorAppointment.doctorName]
  static final doctorName =
      obx.QueryStringProperty<DoctorAppointment>(_entities[1].properties[1]);

  /// see [DoctorAppointment.hospitalName]
  static final hospitalName =
      obx.QueryStringProperty<DoctorAppointment>(_entities[1].properties[2]);

  /// see [DoctorAppointment.imageUrl]
  static final imageUrl =
      obx.QueryStringProperty<DoctorAppointment>(_entities[1].properties[3]);

  /// see [DoctorAppointment.dateTime]
  static final dateTime =
      obx.QueryDateProperty<DoctorAppointment>(_entities[1].properties[4]);

  /// see [DoctorAppointment.specialty]
  static final specialty =
      obx.QueryStringProperty<DoctorAppointment>(_entities[1].properties[5]);

  /// see [DoctorAppointment.notes]
  static final notes =
      obx.QueryStringProperty<DoctorAppointment>(_entities[1].properties[6]);
}
