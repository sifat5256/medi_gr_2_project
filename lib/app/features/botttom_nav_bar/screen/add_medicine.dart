// screens/add_edit_medicine_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/medicine_model.dart';
import '../controller/medicine_controller.dart';


class AddEditMedicineScreen extends StatefulWidget {
  final Medicine? medicine;

  AddEditMedicineScreen({this.medicine, Key? key}) : super(key: key);

  @override
  _AddEditMedicineScreenState createState() => _AddEditMedicineScreenState();
}

class _AddEditMedicineScreenState extends State<AddEditMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  final controller = Get.find<MedicineController>();
  String? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _selectedTimes = [];
  bool _notificationsEnabled = true;
  String? _imagePath;
  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final formattedTime = DateFormat('h:mm a').format(
        DateTime(0, 0, 0, time.hour, time.minute),
      );
      if (!_selectedTimes.contains(formattedTime)) {
        setState(() {
          _selectedTimes.add(formattedTime);
          _selectedTimes.sort();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.medicine != null) {
      // Editing existing medicine
      final medicine = widget.medicine!;
      _nameController.text = medicine.name;
      _selectedType = medicine.type;
      _imagePath = medicine.imagePath;
      _startDate = medicine.startDate;
      _endDate = medicine.endDate;
      _selectedTimes = List.from(medicine.reminderTimes);
      _notificationsEnabled = medicine.notificationsEnabled;
      _quantityController.text = medicine.totalQuantity.toString();
      _dosageController.text = medicine.dosage;
      _notesController.text = medicine.notes;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now().add(Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        if (isStartDate) {
          _startDate = date;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate!.add(Duration(days: 1));
          }
        } else {
          _endDate = date;
        }
      });
    }
  }

  void _toggleTimeSelection(String time) {
    setState(() {
      if (_selectedTimes.contains(time)) {
        _selectedTimes.remove(time);
      } else {
        _selectedTimes.add(time);
      }
      _selectedTimes.sort();
    });
  }

  void _saveMedicine() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null || _startDate == null || _endDate == null || _selectedTimes.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    final medicine = Medicine(
      id: widget.medicine?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      type: _selectedType!,
      imagePath: _imagePath ?? '',
      startDate: _startDate!,
      endDate: _endDate!,
      reminderTimes: _selectedTimes,
      notificationsEnabled: _notificationsEnabled,
      totalQuantity: int.parse(_quantityController.text),
      currentQuantity: widget.medicine?.currentQuantity ?? int.parse(_quantityController.text),
      dosage: _dosageController.text.trim(),
      notes: _notesController.text.trim(),
    );

    if (widget.medicine == null) {
      controller.addMedicine(medicine);
    } else {
      controller.updateMedicine(medicine.id, medicine);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medicine == null ? 'Add Medicine' : 'Edit Medicine'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveMedicine,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(),
              SizedBox(height: 20),
              _buildBasicInfoSection(),
              SizedBox(height: 20),
              _buildScheduleSection(),
              SizedBox(height: 20),
              _buildQuantitySection(),
              SizedBox(height: 20),
              _buildNotesSection(),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveMedicine,
                child: Text('Save Medicine'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Implement image picking logic
          Get.snackbar('Info', 'Image picker would open here');
        },
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[200],
          backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
          child: _imagePath == null ? Icon(Icons.add_a_photo, size: 30) : null,
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Basic Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Medicine Name*',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medication),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Type*',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: controller.medicineTypes
                  .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedType = value),
              validator: (value) => value == null ? 'Required' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _dosageController,
              decoration: InputDecoration(
                labelText: 'Dosage (e.g., 1 tablet)*',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medical_services),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Schedule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context, true),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20),
                          SizedBox(width: 10),
                          Text(
                            _startDate == null
                                ? 'Start Date*'
                                : DateFormat('MMM dd, yyyy').format(_startDate!),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context, false),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20),
                          SizedBox(width: 10),
                          Text(
                            _endDate == null
                                ? 'End Date*'
                                : DateFormat('MMM dd, yyyy').format(_endDate!),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Reminder Times*',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._selectedTimes.map((time) {
                  return Chip(
                    label: Text(time),
                    onDeleted: () {
                      setState(() {
                        _selectedTimes.remove(time);
                      });
                    },
                    deleteIcon: Icon(Icons.close, size: 16),
                  );
                }).toList(),
                ActionChip(
                  label: Text('Add Time'),
                  onPressed: _pickTime,
                  avatar: Icon(Icons.add, size: 16),
                ),
              ],
            ),

            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: (value) => setState(() => _notificationsEnabled = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quantity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Total Quantity*',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.format_list_numbered),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Required';
                if (int.tryParse(value) == null) return 'Invalid number';
                return null;
              },
            ),
            if (widget.medicine != null) ...[
              SizedBox(height: 16),
              TextFormField(
                initialValue: widget.medicine!.currentQuantity.toString(),
                decoration: InputDecoration(
                  labelText: 'Current Quantity',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.exposure),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Update current quantity if needed
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Additional Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}