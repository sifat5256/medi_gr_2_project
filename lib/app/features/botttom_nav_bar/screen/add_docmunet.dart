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
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedFile = File(picked.path));
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
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
    if (_selectedDate == null || _selectedFile == null || _selectedDocumentType == null) {
      Get.snackbar(
        "Error",
        "Please select date, file and document type",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
        title: Text("Add Document"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Document Title",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) =>
                value!.isEmpty ? "Please enter title" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDocumentType,
                decoration: InputDecoration(
                  labelText: "Document Type",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: controller.documentTypes
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedDocumentType = value),
                validator: (value) =>
                value == null ? "Please select document type" : null,
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () => _pickDate(context),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 16),
                      Text(
                        _selectedDate == null
                            ? "Select Date"
                            : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                        style: TextStyle(
                          fontSize: 16,
                          color:
                          _selectedDate == null ? Colors.grey : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickFile,
                child: Text(
                  _selectedFile == null
                      ? "Select Document File"
                      : "File Selected: ${_selectedFile!.path.split('/').last}",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text(
                  _selectedImage == null
                      ? "Select Preview Image (Optional)"
                      : "Image Selected",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (_selectedImage != null) ...[
                SizedBox(height: 16),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 24),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : _saveDocument,
                child: controller.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Save Document"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
