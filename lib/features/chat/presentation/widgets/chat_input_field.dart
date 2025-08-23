import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Chat input field widget with send button
class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final String hintText;
  final Function(String imagePath, String fileName)? onFileSelected;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.hintText,
    this.onFileSelected,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.full),
              border: Border.all(color: AppColors.outline.withOpacity(0.3)),
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              onSubmitted: (_) => _handleSend(),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textDisabled,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                suffixIcon: _buildAttachmentButton(),
              ),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _buildSendButton(),
      ],
    );
  }

  Widget _buildAttachmentButton() {
    return IconButton(
      onPressed: _showAttachmentOptions,
      icon: Icon(
        Icons.attach_file,
        color: AppColors.textSecondary,
        size: AppSpacing.iconSize,
      ),
      tooltip: 'Attach file',
    );
  }

  Widget _buildSendButton() {
    return Container(
      decoration: BoxDecoration(
        color: _hasText ? AppColors.primary : AppColors.textDisabled,
        borderRadius: BorderRadius.circular(AppSpacing.full),
      ),
      child: IconButton(
        onPressed: _hasText ? _handleSend : null,
        icon: Icon(
          Icons.send,
          color: AppColors.textInverse,
          size: AppSpacing.iconSize,
        ),
        tooltip: 'Send message',
      ),
    );
  }

  void _handleSend() {
    if (_hasText) {
      widget.onSend();
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.lg),
                topRight: Radius.circular(AppSpacing.lg),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.textDisabled,
                      borderRadius: BorderRadius.circular(AppSpacing.full),
                    ),
                  ),
                  _buildAttachmentOption(
                    icon: Icons.image,
                    label: 'Photo or Video',
                    onTap: () => _handleAttachment('image'),
                  ),
                  _buildAttachmentOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () => _handleAttachment('camera'),
                  ),
                  _buildAttachmentOption(
                    icon: Icons.psychology,
                    label: 'Personality Assessment',
                    onTap: () => _handleAttachment('assessment'),
                  ),
                  _buildAttachmentOption(
                    icon: Icons.insights,
                    label: 'MBTI Results',
                    onTap: () => _handleAttachment('results'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Icon(icon, color: AppColors.primary, size: AppSpacing.iconSize),
      ),
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    );
  }

  void _handleAttachment(String type) async {
    try {
      switch (type) {
        case 'image':
          await _pickImageFromGallery();
          break;
        case 'camera':
          await _pickImageFromCamera();
          break;
        case 'assessment':
          _showAssessmentOptions();
          break;
        case 'results':
          _showResultsOptions();
          break;
        default:
          _showFeatureComingSoon(type);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final status = await Permission.photos.request();
    
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (image != null) {
        await _processSelectedImage(image);
      }
    } else if (status.isDenied) {
      // Permission denied, show dialog to explain and retry
      _showPermissionDialog(
        title: 'Photo Permission Required',
        message: 'This app needs access to your photos to select images for sharing. Please grant permission to continue.',
        onRetry: _pickImageFromGallery,
      );
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, redirect to settings
      _showPermissionSettingsDialog(
        title: 'Photo Permission Denied',
        message: 'Photo permission has been permanently denied. Please enable it in your device settings to select images.',
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    final status = await Permission.camera.request();
    
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (image != null) {
        await _processSelectedImage(image);
      }
    } else if (status.isDenied) {
      // Permission denied, show dialog to explain and retry
      _showPermissionDialog(
        title: 'Camera Permission Required',
        message: 'This app needs access to your camera to take photos for sharing. Please grant permission to continue.',
        onRetry: _pickImageFromCamera,
      );
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, redirect to settings
      _showPermissionSettingsDialog(
        title: 'Camera Permission Denied',
        message: 'Camera permission has been permanently denied. Please enable it in your device settings to take photos.',
      );
    }
  }

  Future<void> _processSelectedImage(XFile image) async {
    if (!mounted) return;
    
    final File imageFile = File(image.path);
    final fileName = image.name;
    final fileSize = await imageFile.length();
    
    // Check file size (limit to 10MB)
    if (fileSize > 10 * 1024 * 1024) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image is too large. Please select an image under 10MB.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show preview dialog
    final shouldSend = await _showImagePreview(imageFile, fileName);
    if (shouldSend == true) {
      // Here you would typically upload to server and get URL
      // For now, we'll use the local file path
      _sendImageMessage(image.path, fileName);
    }
  }

  Future<bool?> _showImagePreview(File imageFile, String fileName) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.md),
                border: Border.all(color: AppColors.outline.withOpacity(0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.md),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              fileName,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _sendImageMessage(String imagePath, String fileName) {
    if (widget.onFileSelected != null) {
      // Use the callback if provided
      widget.onFileSelected!(imagePath, fileName);
    } else {
      // Fallback: add text to indicate an image was selected
      widget.controller.text = '[Image: $fileName]';
      widget.onSend();
    }
  }

  void _showAssessmentOptions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Personality assessment feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showResultsOptions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('MBTI results sharing feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showFeatureComingSoon(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type attachment feature coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPermissionDialog({
    required String title,
    required String message,
    required VoidCallback onRetry,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: AppColors.warning),
            const SizedBox(width: AppSpacing.sm),
            Flexible(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textInverse,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showPermissionSettingsDialog({
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.settings, color: AppColors.primary),
            const SizedBox(width: AppSpacing.sm),
            Flexible(child: Text(title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Go to Settings > Apps > ${_getAppName()} > Permissions',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textInverse,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  String _getAppName() {
    return 'MBTI Explorer'; // You can make this dynamic if needed
  }
}
