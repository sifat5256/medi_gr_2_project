import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../../models/medical_document_model.dart';
import '../controller/document_controller.dart';

class AddDocumentScreen extends StatefulWidget {
  @override
  _AddDocumentScreenState createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final controller = Get.find<MedicalDocumentController>();
  DateTime? _selectedDate;
  File? _selectedFile;
  File? _selectedImage;
  String? _selectedDocumentType;

  Future<void> _pickFile() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _selectedFile = File(picked.path));
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to select file: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to select image: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _selectedDate ?? now;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
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
      setState(() => _selectedDate = date);
    }
  }

  void _saveDocument() {
    if (!_formKey.currentState!.validate()) return;

    final missingFields = <String>[];
    if (_selectedDate == null) missingFields.add("date");
    if (_selectedFile == null) missingFields.add("document file");
    if (_selectedDocumentType == null) missingFields.add("document type");

    if (missingFields.isNotEmpty) {
      Get.snackbar(
        "Missing Information",
        "Please select: ${missingFields.join(', ')}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      );
      return;
    }

    final document = MedicalDocument(
      title: _titleController.text.trim(),
      date: _selectedDate!,
      imagePath: _selectedImage?.path,
      filePath: _selectedFile!.path,
      description: _descriptionController.text.trim(),
      documentType: _selectedDocumentType!,
    );

    controller.addDocument(document);
    Get.back();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Medical Document",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Document Information Section
              _buildSectionTitle("Document Information"),
              SizedBox(height: 8),

              // Title Field
              _buildTextField(
                controller: _titleController,
                label: "Document Title *",
                icon: Icons.title,
                validator: (value) =>
                value!.isEmpty ? "Title is required" : null,
              ),
              SizedBox(height: 16),

              // Document Type Dropdown
              _buildDocumentTypeDropdown(),
              SizedBox(height: 16),

              // Date Picker
              _buildDatePicker(context),
              SizedBox(height: 24),

              // Document File Section
              _buildSectionTitle("Document File *"),
              SizedBox(height: 8),
              _buildFilePicker(),
              SizedBox(height: 16),

              // Preview Image Section
              _buildSectionTitle("Preview Image (Optional)"),
              SizedBox(height: 8),
              _buildImagePicker(),
              SizedBox(height: 24),

              // Description Section
              _buildSectionTitle("Description"),
              SizedBox(height: 8),
              _buildDescriptionField(),
              SizedBox(height: 32),

              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.teal.shade700,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
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

  Widget _buildDocumentTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDocumentType,
      decoration: InputDecoration(
        labelText: "Document Type *",
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
        prefixIcon: Icon(Icons.category, color: Colors.teal),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
      items: controller.documentTypes
          .map((type) => DropdownMenuItem(
        value: type,
        child: Text(type),
      ))
          .toList(),
      onChanged: (value) => setState(() => _selectedDocumentType = value),
      validator: (value) => value == null ? "Please select document type" : null,
      isExpanded: true,
      icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      style: TextStyle(color: Colors.black87, fontSize: 16),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () => _pickDate(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.teal),
            SizedBox(width: 16),
            Text(
              _selectedDate == null
                  ? "Select Document Date *"
                  : DateFormat('MMM dd, yyyy').format(_selectedDate!),
              style: TextStyle(
                fontSize: 16,
                color: _selectedDate == null ? Colors.grey : Colors.black87,
              ),
            ),
            Spacer(),
            if (_selectedDate != null)
              IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() => _selectedDate = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePicker() {
    return Column(
      children: [
        OutlinedButton(
          onPressed: _pickFile,
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
              Icon(Icons.insert_drive_file, color: Colors.teal),
              SizedBox(width: 8),
              Text(
                _selectedFile == null
                    ? "Choose Document File"
                    : "Change File",
                style: TextStyle(color: Colors.teal),
              ),
            ],
          ),
        ),
        if (_selectedFile != null) ...[
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.file_present, color: Colors.teal),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedFile!.path.split('/').last,
                    style: TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 18),
                  onPressed: () {
                    setState(() => _selectedFile = null);
                  },
                ),
              ],
            ),
          ),
        ],
      ],
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
              Icon(Icons.image, color: Colors.teal),
              SizedBox(width: 8),
              Text(
                _selectedImage == null
                    ? "Choose Preview Image"
                    : "Change Image",
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

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        hintText: "Enter document description...",
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
      onPressed: controller.isLoading.value ? null : _saveDocument,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(vertical: 18),
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
        "SAVE DOCUMENT",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ));
  }
}