/**
 * storage_service.dart
 * 
 * Firebase Storage service for image uploads
 * 
 * Handles uploading images to Firebase Storage and returning download URLs.
 * Provides image compression and validation before upload.
 * 
 * Author: Siddak Bath
 * Created: [17/07/2025]
 * Last Modified: [05/08/2025]
 */

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

/**
 * Firebase Storage service for image operations
 * 
 * Provides methods for uploading images to Firebase Storage and managing
 * image files. Handles image validation, compression, and URL generation.
 * 
 * Key Features:
 * - Image upload to Firebase Storage
 * - Automatic file naming with UUID
 * - Image validation and error handling
 * - Download URL generation
 * 
 * Storage Structure:
 * - Bucket: Default Firebase Storage bucket
 * - Path: 'report_images/{uuid}.jpg'
 * - Access: Public read access for image URLs
 */
class StorageService {
  // Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // UUID generator for unique file names
  final Uuid _uuid = Uuid();

  /**
   * Upload image file to Firebase Storage
   * 
   * Input: File imageFile
   * Processing: 
   * - Generate unique filename with UUID
   * - Upload file to Firebase Storage
   * - Return download URL for the uploaded image
   * Output: Future<String> - Download URL of uploaded image
   */
  Future<String> uploadImage(File imageFile) async {
    try {
      // Validate image before upload
      if (!validateImage(imageFile)) {
        throw Exception(
          'Invalid image file. Please select a valid image (max 5MB).',
        );
      }

      // Generate unique filename
      final String fileName = '${_uuid.v4()}.jpg';
      final String filePath = 'report_images/$fileName';

      // Create storage reference
      final Reference storageRef = _storage.ref().child(filePath);

      // Upload file with metadata
      final UploadTask uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedAt': DateTime.now().toIso8601String(),
            'originalName': imageFile.path.split('/').last,
          },
        ),
      );

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      if (e.toString().contains('permission-denied')) {
        throw Exception(
          'Permission denied. Please check your authentication status.',
        );
      } else if (e.toString().contains('storage/unauthorized')) {
        throw Exception('Unauthorized access to storage. Please log in again.');
      } else {
        throw Exception('Failed to upload image: $e');
      }
    }
  }

  /**
   * Delete image from Firebase Storage
   * 
   * Input: String imageUrl
   * Processing: 
   * - Extract file path from URL
   * - Delete file from Firebase Storage
   * Output: Future<void> - Completes when image is successfully deleted
   */
  Future<void> deleteImage(String imageUrl) async {
    try {
      // Extract file path from URL
      final Uri uri = Uri.parse(imageUrl);
      final String filePath = uri.pathSegments.last;

      // Create storage reference
      final Reference storageRef = _storage.ref().child(
        'report_images/$filePath',
      );

      // Delete file
      await storageRef.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  /**
   * Validate image file before upload
   * 
   * Input: File imageFile
   * Processing: 
   * - Check file size (max 5MB)
   * - Validate file extension
   * - Check if file exists
   * Output: bool - True if image is valid for upload
   */
  bool validateImage(File imageFile) {
    try {
      // Check if file exists
      if (!imageFile.existsSync()) {
        print('Image validation failed: File does not exist');
        return false;
      }

      // Check file size (max 5MB)
      final int fileSize = imageFile.lengthSync();
      const int maxSize = 5 * 1024 * 1024; // 5MB
      if (fileSize > maxSize) {
        print(
          'Image validation failed: File size ${fileSize} bytes exceeds limit of $maxSize bytes',
        );
        return false;
      }

      // Check if file is empty
      if (fileSize == 0) {
        print('Image validation failed: File is empty');
        return false;
      }

      // Check file extension
      final String extension = imageFile.path.split('.').last.toLowerCase();
      final List<String> allowedExtensions = [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'bmp',
        'webp',
      ];
      if (!allowedExtensions.contains(extension)) {
        print(
          'Image validation failed: Unsupported file extension: $extension',
        );
        return false;
      }

      print(
        'Image validation passed: ${imageFile.path} (${fileSize} bytes, $extension)',
      );
      return true;
    } catch (e) {
      print('Image validation error: $e');
      return false;
    }
  }
}
