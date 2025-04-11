import 'package:file_picker/file_picker.dart';

class FilePickerHelper {
  // Pick a file (e.g., PDF, DOC)
  static Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      return result.files.single.path; // Get the path of the selected file
    } else {
      return null; // No file selected
    }
  }
}
