import 'dart:io';
import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/core/constants/app_spacing.dart';
import 'package:opop/core/constants/app_typography.dart';
import '../../data/services/media_service.dart';

class CameraGalleryCaptureScreen extends StatefulWidget {
  final String mediaType; // 'camera', 'gallery', 'video'
  
  const CameraGalleryCaptureScreen({
    super.key,
    required this.mediaType,
  });

  @override
  State<CameraGalleryCaptureScreen> createState() => _CameraGalleryCaptureScreenState();
}

class _CameraGalleryCaptureScreenState extends State<CameraGalleryCaptureScreen> {
  final MediaService _mediaService = MediaService();
  File? _selectedMedia;
  bool _isLoading = false;
  String? _errorMessage;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
        ),
        title: Text(
          _getTitle(),
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (_selectedMedia != null)
            TextButton(
              onPressed: _isLoading ? null : _createStory,
              child: Text(
                'Create',
                style: AppTypography.titleMedium.copyWith(
                  color: _isLoading ? AppColors.textDisabled : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppSpacing.md),
            Text('Processing...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Error',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _errorMessage!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                });
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_selectedMedia != null) {
      return _buildMediaPreview();
    }

    return _buildCaptureOptions();
  }

  Widget _buildCaptureOptions() {
    return Column(
      children: [
        // Preview Area
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppSpacing.lg),
              border: Border.all(
                color: AppColors.outline.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIcon(),
                    color: AppColors.textDisabled,
                    size: 80,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _getPlaceholderText(),
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Capture Options
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.lg),
              topRight: Radius.circular(AppSpacing.lg),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Choose Source',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              
              Row(
                children: [
                  if (widget.mediaType == 'camera' || widget.mediaType == 'video')
                    Expanded(
                      child: _buildCaptureOption(
                        icon: Icons.camera_alt,
                        title: 'Camera',
                        subtitle: widget.mediaType == 'video' ? 'Record video' : 'Take photo',
                        color: AppColors.primary,
                        onTap: _captureFromCamera,
                      ),
                    ),
                  if (widget.mediaType == 'camera' || widget.mediaType == 'video')
                    const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildCaptureOption(
                      icon: Icons.photo_library,
                      title: 'Gallery',
                      subtitle: widget.mediaType == 'video' ? 'Choose video' : 'Choose photo',
                      color: AppColors.analyst,
                      onTap: _pickFromGallery,
                    ),
                  ),
                ],
              ),
              
              if (widget.mediaType == 'camera') ...[
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: _pickMultipleFromGallery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.diplomat,
                    foregroundColor: AppColors.textInverse,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Select Multiple Photos'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCaptureOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: AppSpacing.iconSize * 1.5,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Column(
      children: [
        // Media Preview
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.lg),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.lg),
              child: widget.mediaType == 'video'
                  ? _buildVideoPreview()
                  : _buildImagePreview(),
            ),
          ),
        ),
        
        // Media Options
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.lg),
              topRight: Radius.circular(AppSpacing.lg),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedMedia = null;
                        });
                      },
                      child: const Text('Retake'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createStory,
                      child: const Text('Create Story'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          _selectedMedia!,
          fit: BoxFit.cover,
        ),
        // Video indicator if it's a video file
        if (_selectedMedia!.path.toLowerCase().endsWith('.mp4') ||
            _selectedMedia!.path.toLowerCase().endsWith('.mov') ||
            _selectedMedia!.path.toLowerCase().endsWith('.avi'))
          Positioned(
            top: AppSpacing.md,
            right: AppSpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(AppSpacing.xs),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_arrow,
                    color: AppColors.textInverse,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'VIDEO',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textInverse,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video thumbnail would go here
        Container(
          color: AppColors.surfaceVariant,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_filled,
                  color: AppColors.primary,
                  size: 80,
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Video Selected',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: AppSpacing.md,
          right: AppSpacing.md,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(AppSpacing.xs),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.play_arrow,
                  color: AppColors.textInverse,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'VIDEO',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getTitle() {
    switch (widget.mediaType) {
      case 'camera':
        return 'Create Photo Story';
      case 'gallery':
        return 'Create Photo Story';
      case 'video':
        return 'Create Video Story';
      default:
        return 'Create Story';
    }
  }

  IconData _getIcon() {
    switch (widget.mediaType) {
      case 'camera':
        return Icons.camera_alt;
      case 'gallery':
        return Icons.photo_library;
      case 'video':
        return Icons.videocam;
      default:
        return Icons.add_photo_alternate;
    }
  }

  String _getPlaceholderText() {
    switch (widget.mediaType) {
      case 'camera':
        return 'Take a photo or select from gallery';
      case 'gallery':
        return 'Select a photo from your gallery';
      case 'video':
        return 'Record a video or select from gallery';
      default:
        return 'Select media for your story';
    }
  }

  Future<void> _captureFromCamera() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      File? media;
      if (widget.mediaType == 'video') {
        media = await _mediaService.pickVideoFromCamera();
      } else {
        media = await _mediaService.pickImageFromCamera();
      }

      if (media != null) {
        setState(() {
          _selectedMedia = media;
        });
      } else {
        setState(() {
          _errorMessage = 'No media selected';
        });
      }
    } catch (e) {
      if (e.toString().contains('permission')) {
        _mediaService.showPermissionDeniedDialog(context, 'Camera');
      } else {
        setState(() {
          _errorMessage = 'Failed to capture media: ${e.toString()}';
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      File? media;
      if (widget.mediaType == 'video') {
        media = await _mediaService.pickVideoFromGallery();
      } else {
        media = await _mediaService.pickImageFromGallery();
      }

      if (media != null) {
        setState(() {
          _selectedMedia = media;
        });
      } else {
        setState(() {
          _errorMessage = 'No media selected';
        });
      }
    } catch (e) {
      if (e.toString().contains('permission')) {
        _mediaService.showPermissionDeniedDialog(context, 'Gallery');
      } else {
        setState(() {
          _errorMessage = 'Failed to pick media: ${e.toString()}';
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickMultipleFromGallery() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final List<File>? media = await _mediaService.pickMultipleImagesFromGallery();

      if (media != null && media.isNotEmpty) {
        // For now, just use the first image selected
        setState(() {
          _selectedMedia = media.first;
        });
        
        _mediaService.showSuccessMessage(
          context, 
          'Selected ${media.length} image${media.length > 1 ? 's' : ''}',
        );
      } else {
        setState(() {
          _errorMessage = 'No media selected';
        });
      }
    } catch (e) {
      if (e.toString().contains('permission')) {
        _mediaService.showPermissionDeniedDialog(context, 'Gallery');
      } else {
        setState(() {
          _errorMessage = 'Failed to pick media: ${e.toString()}';
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _createStory() {
    if (_selectedMedia == null) return;

    final storyData = {
      'type': widget.mediaType == 'video' ? 'video' : 'image',
      'mediaPath': _selectedMedia!.path,
      'timestamp': DateTime.now(),
      'isVideo': widget.mediaType == 'video',
    };

    _mediaService.showSuccessMessage(context, 'Story created successfully! 📸');
    Navigator.pop(context, storyData);
  }
}