import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart';

@Entity()
class MedicalDocument {
  @Id()
  int id = 0;

  String title;
  DateTime date;
  String? imagePath;
  String filePath;
  String description;
  String documentType;

  MedicalDocument({
    this.id = 0,
    required this.title,
    required this.date,
    this.imagePath,
    required this.filePath,
    required this.description,
    required this.documentType,
  });

  String get formattedDate => DateFormat.yMMMMd().format(date);
  String get fileExtension => filePath.split('.').last.toUpperCase();
}