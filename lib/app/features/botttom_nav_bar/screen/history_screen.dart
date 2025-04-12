// screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/medicine_controller.dart';

class HistoryScreen extends StatelessWidget {
  final MedicineController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final historyByDate = controller.getHistoryByDate();
    final dates = historyByDate.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text('Medicine History'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ...dates.map((date) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    DateFormat('MMMM dd, yyyy').format(date),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ...historyByDate[date]!.map((entry) {
                  return ListTile(
                    leading: Icon(
                      entry.taken ? Icons.check_circle : Icons.cancel,
                      color: entry.taken ? Colors.green : Colors.red,
                    ),
                    title: Text(entry.medicineName),
                    subtitle: Text('${entry.time.format(context)} - ${entry.taken ? 'Taken' : 'Missed'}'),
                  );
                }).toList(),
                Divider(),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}