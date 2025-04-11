// screens/home_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/medicine_model.dart';
import '../controller/doctor_appointment_controller.dart';
import '../controller/medicine_controller.dart';

import 'add_medicine.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MedicineController controller = Get.put(MedicineController());
  final AppointmentController controller1 = Get.put(AppointmentController());
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: controller1.appointments.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Upcoming Appointments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Your schedule is clear for now. Add new appointments to keep track of your medical visits.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ),

                ],
              ),
            )
                :  ListView.builder(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: controller1.appointments.length,
              itemBuilder: (context, index) {
                final appointment = controller1.appointments[index];
                return Dismissible(
                  key: Key(appointment.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red[400],
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirm Delete"),
                        content: const Text("Delete this appointment permanently?"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancel",
                                style: TextStyle(color: Colors.grey)),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: const Text("Delete",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    controller1.deleteAppointment(appointment.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Deleted: ${appointment.doctorName}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        action: SnackBarAction(
                          label: 'Undo',
                          textColor: Colors.blue,
                          onPressed: () {
                            // Implement undo functionality
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            "Upcoming Appointment",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 22, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                appointment.dayOfWeek,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[50],
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blue[50],
                                image: appointment.imageUrl.isNotEmpty
                                    ? DecorationImage(
                                  image: FileImage(File(appointment.imageUrl)),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: appointment.imageUrl.isEmpty
                                  ? const Icon(Icons.person,
                                  size: 30, color: Colors.grey)
                                  : null,
                            ),
                            title: Text(
                              appointment.doctorName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  appointment.hospitalName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appointment.specialty,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (appointment.notes.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    "Notes: ${appointment.notes}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  appointment.formattedTime,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ),
          _buildDateSelector(),
          Divider(height: 1),

          Expanded(
            flex: 3,
            child: Obx(() {
              final medicinesForDate = controller.filteredMedicines
                  .where((med) =>
              med.startDate.isBefore(_selectedDate.add(Duration(days: 1))) &&
                  med.endDate.isAfter(_selectedDate.subtract(Duration(days: 1))))
                  .toList();

              if (medicinesForDate.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medication, size: 50, color: Colors.grey[300]),
                      SizedBox(height: 16),
                      Text(
                        'No medicines scheduled for\n${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: medicinesForDate.length,
                itemBuilder: (context, index) {
                  return _buildMedicineCard(medicinesForDate[index]);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Get.to(() => AddEditMedicineScreen()),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8,right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('d MMMM yyyy').format(_selectedDate),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap:() => Get.to(() => HistoryScreen()),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey,

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("History"),
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.history),
                //   onPressed: () => Get.to(() => HistoryScreen()),
                // ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 30,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index - 15));
                final isSelected = DateUtils.isSameDay(date, _selectedDate);
                final hasMedicines = controller.medicines.any((med) =>
                !med.startDate.isAfter(date) && !med.endDate.isBefore(date));

                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: hasMedicines
                            ? Colors.green
                            : Colors.grey.withOpacity(0.3),
                        width: hasMedicines ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E').format(date),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMedicineCard(Medicine medicine) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: InkWell(
        onTap: () => Get.to(() => AddEditMedicineScreen(medicine: medicine)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: medicine.imagePath.isNotEmpty
                        ? FileImage(File(medicine.imagePath))
                        : null,
                    child: medicine.imagePath.isEmpty
                        ? Icon(Icons.medication, color: Colors.blue)
                        : null,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${medicine.type} • ${medicine.dosage}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  _buildProgressIndicator(medicine.currentQuantity / medicine.totalQuantity),
                ],
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: medicine.reminderTimes.map((time) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(color: Colors.blue),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${medicine.currentQuantity} of ${medicine.totalQuantity} remaining',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => _recordMedicineTaken(medicine, true),
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _recordMedicineTaken(medicine, false),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _recordMedicineTaken(Medicine medicine, bool taken) {
    controller.recordMedicineTaken(medicine, _selectedDate, taken);
    Get.snackbar(
      taken ? 'Medicine Taken' : 'Missed Medicine',
      '${medicine.name} marked as ${taken ? 'taken' : 'missed'}',
      backgroundColor: taken ? Colors.green.shade100 : Colors.red.shade100,
    );
  }



  Widget _buildProgressIndicator(double progress) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 0.25
                  ? Colors.green
                  : progress > 0.1
                  ? Colors.orange
                  : Colors.red,
            ),
          ),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String? _getNextDoseTime(Medicine medicine) {
    final now = TimeOfDay.now();
    final currentTime = '${now.hour}:${now.minute}';

    for (var time in medicine.reminderTimes) {
      final time24 = _convertTo24HourFormat(time);
      if (time24.compareTo(currentTime) > 0) {
        return time;
      }
    }
    return medicine.reminderTimes.isNotEmpty ? medicine.reminderTimes.first : null;
  }

  String _convertTo24HourFormat(String time12) {
    final format = DateFormat('h:mm a');
    final date = format.parse(time12);
    return '${date.hour}:${date.minute}';
  }

  void _showDeleteDialog(Medicine medicine) {
    Get.defaultDialog(
      title: 'Delete Medicine',
      middleText: 'Are you sure you want to delete ${medicine.name}?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteMedicine(medicine.id);
        Get.back();
      },
    );
  }
}

