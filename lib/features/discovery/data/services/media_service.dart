import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromCamera() async {
    try {
      // Request camera permission
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Camera permission denied');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      // Request gallery permission
      final status = await Permission.photos.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Gallery permission denied');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  Future<File?> pickVideoFromCamera() async {
    try {
      // Request camera and microphone permissions
      final cameraStatus = await Permission.camera.request();
      final micStatus = await Permission.microphone.request();

      if (cameraStatus != PermissionStatus.granted ||
          micStatus != PermissionStatus.granted) {
        throw Exception('Camera or microphone permission denied');
      }

      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxDuration: const Duration(seconds: 30), // 30 second limit for stories
      );

      if (video != null) {
        return File(video.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking video from camera: $e');
      return null;
    }
  }

  Future<File?> pickVideoFromGallery() async {
    try {
      // Request gallery permission
      final status = await Permission.photos.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Gallery permission denied');
      }

      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 30), // 30 second limit for stories
      );

      if (video != null) {
        return File(video.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking video from gallery: $e');
      return null;
    }
  }

  Future<List<File>?> pickMultipleImagesFromGallery() async {
    try {
      // Request gallery permission
      final status = await Permission.photos.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Gallery permission denied');
      }

      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
        limit: 10, // Max 10 images for story
      );

      if (images.isNotEmpty) {
        return images.map((image) => File(image.path)).toList();
      }
      return null;
    } catch (e) {
      debugPrint('Error picking multiple images from gallery: $e');
      return null;
    }
  }

  void showPermissionDeniedDialog(BuildContext context, String permissionType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(
          '$permissionType permission is required to access this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Global instance
final mediaService = MediaService();
