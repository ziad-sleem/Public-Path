import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Reduce quality to save space
        maxWidth: 800, // Limit width
        maxHeight: 800, // Limit height
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  /// Pick an image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image from camera: $e');
    }
  }

  /// Show image source selection dialog and return selected image
  Future<File?> pickImageWithSourceSelection() async {
    // This will be handled in the UI with a dialog
    // For now, default to gallery
    return pickImageFromGallery();
  }

  /// Convert image file to base64 string
  Future<String?> imageToBase64(File? imageFile) async {
    if (imageFile == null) return null;

    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      return base64String;
    } catch (e) {
      throw Exception('Failed to convert image to base64: $e');
    }
  }

  /// Convert base64 string to image bytes
  Uint8List? base64ToImageBytes(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;

    try {
      return base64Decode(base64String);
    } catch (e) {
      return null;
    }
  }
}