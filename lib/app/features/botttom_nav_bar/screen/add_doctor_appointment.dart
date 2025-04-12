import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../../models/doctor_appointment_model.dart';
import '../controller/doctor_appointment_controller.dart';

class AddAppointmentScreen extends StatefulWidget {
  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doctorNameController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _notesController = TextEditingController();
  final controller = Get.find<AppointmentController>();
  DateTime? _selectedDateTime;
  File? _selectedImage;

  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: ${e.toString()}");
    }
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _selectedDateTime ?? now;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: _selectedDateTime != null
            ? TimeOfDay.fromDateTime(_selectedDateTime!)
            : TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.teal,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false,
              ),
              child: child!,
            ),
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveAppointment() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDateTime == null) {
      Get.snackbar(
        "Select Date & Time",
        "Please select appointment date and time",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
      return;
    }

    final appointment = DoctorAppointment(
      doctorName: _doctorNameController.text.trim(),
      hospitalName: _hospitalController.text.trim(),
      specialty: _specialtyController.text.trim(),
      dateTime: _selectedDateTime!,
      imageUrl: _selectedImage?.path ?? '',
      notes: _notesController.text.trim(),
    );

    controller.addAppointment(appointment);
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    _hospitalController.dispose();
    _specialtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text(
          "Add Appointment",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Doctor Name Field
              _buildSectionTitle("Doctor Information"),
              _buildTextField(
                controller: _doctorNameController,
                label: "Doctor Name",
                icon: Icons.person_outline,
                isRequired: true,
                validator: (value) =>
                value!.isEmpty ? "Doctor name is required" : null,
              ),
              const SizedBox(height: 16),

              // Hospital/Clinic Field
              _buildTextField(
                controller: _hospitalController,
                label: "Hospital/Clinic Name",
                icon: Icons.local_hospital_outlined,
              ),
              const SizedBox(height: 16),

              // Specialty Field
              _buildTextField(
                controller: _specialtyController,
                label: "Specialty",
                icon: Icons.medical_services_outlined,
              ),
              const SizedBox(height: 24),

              // Date & Time Picker
              _buildSectionTitle("Appointment Time"),
              _buildDateTimePicker(context),
              const SizedBox(height: 24),

              // Image Picker
              _buildSectionTitle("Doctor Photo (Optional)"),
              _buildImagePicker(),
              const SizedBox(height: 24),

              // Notes Field
              _buildSectionTitle("Additional Notes"),
              _buildNotesField(),
              const SizedBox(height: 32),

              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.teal.shade700,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label + (isRequired ? " *" : ""),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: Icon(icon, color: Colors.teal),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: validator,
    );
  }

  Widget _buildDateTimePicker(BuildContext context) {
    return InkWell(
      onTap: () => _pickDateTime(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.teal),
            const SizedBox(width: 16),
            Text(
              _selectedDateTime == null
                  ? "Select Date & Time"
                  : DateFormat('EEE, MMM d • h:mm a').format(_selectedDateTime!),
              style: TextStyle(
                fontSize: 16,
                color: _selectedDateTime == null ? Colors.grey : Colors.black87,
              ),
            ),
            Spacer(),
            if (_selectedDateTime != null)
              IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() => _selectedDateTime = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        OutlinedButton(
          onPressed: _pickImage,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: BorderSide(color: Colors.teal),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined, color: Colors.teal),
              SizedBox(width: 8),
              Text(
                _selectedImage == null
                    ? "Choose Photo"
                    : "Change Photo",
                style: TextStyle(color: Colors.teal),
              ),
            ],
          ),
        ),
        if (_selectedImage != null) ...[
          SizedBox(height: 16),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: Icon(Icons.close, size: 16),
                    onPressed: () {
                      setState(() => _selectedImage = null);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: InputDecoration(
        labelText: "Write your notes here...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.all(16),
      ),
      maxLines: 4,
    );
  }

  Widget _buildSaveButton() {
    return Obx(() => ElevatedButton(
      onPressed: controller.isLoading.value ? null : _saveAppointment,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: controller.isLoading.value
          ? SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : Text(
        "SAVE APPOINTMENT",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ));
  }
}