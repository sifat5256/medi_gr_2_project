import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../controller/doctor_appointment_controller.dart';
import 'add_doctor_appointment.dart';

class AppointmentScreen extends StatelessWidget {
  final AppointmentController controller = Get.put(AppointmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Obx(() {
        if (controller.isLoading.value && !controller.isStoreInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.isStoreInitialized.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                const Text("Database not initialized",
                    style: TextStyle(fontSize: 18, color: Colors.red)),
                if (controller.initializationError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Error: ${controller.initializationError.value}",
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.retryInitialization,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Retry Database Connection"),
                ),
              ],
            ),
          );
        }

        if (controller.appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text("No appointments scheduled",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 8),
                Text("Tap the + button to add one",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    )),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          itemCount: controller.appointments.length,
          itemBuilder: (context, index) {
            final appointment = controller.appointments[index];
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
                controller.deleteAppointment(appointment.id);
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
        );
      }),
      floatingActionButton: Obx(() => FloatingActionButton(
        heroTag: "appointment",
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        child: const Icon(Icons.add, size: 28),
        onPressed: controller.isStoreInitialized.value
            ? () => Get.to(() => AddAppointmentScreen())
            : null,
      )),
    );
  }
}