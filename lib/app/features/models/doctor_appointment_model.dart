import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart';

@Entity()
class DoctorAppointment {
  @Id(assignable: true)
  int id = 0;

  String doctorName;
  String hospitalName;
  String specialty;
  DateTime dateTime;
  String imageUrl;
  String notes;

  DoctorAppointment({
    this.id = 0,
    required this.doctorName,
    required this.hospitalName,
    required this.specialty,
    required this.dateTime,
    required this.imageUrl,
    this.notes = '',
  });

  String get formattedDate => DateFormat.yMMMMd().format(dateTime);
  String get formattedTime => DateFormat.jm().format(dateTime);
  String get dayOfWeek => DateFormat.EEEE().format(dateTime);

  @override
  String toString() {
    return 'DoctorAppointment{id: $id, doctorName: $doctorName, dateTime: $dateTime}';
  }
}