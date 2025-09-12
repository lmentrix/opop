import 'dart:io';

import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/core/constants/app_spacing.dart';
import 'package:opop/core/constants/app_typography.dart';
import 'package:opop/features/discovery/data/models/post_creation_data.dart';
import 'package:opop/features/discovery/data/services/media_service.dart';

class PostCreationScreen extends StatefulWidget {
  const PostCreationScreen({super.key});

  @override
  State<PostCreationScreen> createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  final MediaService _mediaService = MediaService();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();

  File? _selectedMedia;
  String _postType = PostCreationData.defaultPostType;
  bool _isLoading = false;

  final List<String> _mbtiTypes = PostCreationData.mbtiTypes;

  String _selectedMBTI = PostCreationData.defaultMBTIType;
  String _selectedMood = PostCreationData.defaultMood;

  final List<String> _moods = PostCreationData.moods;

  @override
  void dispose() {
    _contentController.dispose();
    _hashtagsController.dispose();
    super.dispose();
  }

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
          'Create Post',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isFormValid ? _createPost : null,
            child: Text(
              'Post',
              style: AppTypography.titleMedium.copyWith(
                color: _isFormValid
                    ? AppColors.primary
                    : AppColors.textDisabled,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Info Header
            _buildUserHeader(),

            // Content Input
            _buildContentSection(),

            // Media Section
            if (_selectedMedia != null) _buildMediaPreview(),

            // Post Options
            _buildPostOptions(),

            // MBTI & Mood Selection
            _buildMBTIMoodSection(),

            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.full),
            ),
            child: const Center(
              child: Text('👤', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _selectedMBTI,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.full),
            ),
            child: Text(
              'Public',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _contentController,
            maxLines: 8,
            minLines: 3,
            decoration: InputDecoration(
              hintText: 'Share your MBTI thoughts, insights, or questions...',
              border: InputBorder.none,
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            onChanged: (_) => setState(() {}),
          ),

          // Media Attachments
          Row(
            children: [
              IconButton(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                color: AppColors.primary,
                tooltip: 'Add Image',
              ),
              IconButton(
                onPressed: _pickVideo,
                icon: const Icon(Icons.videocam),
                color: AppColors.error,
                tooltip: 'Add Video',
              ),
              const Spacer(),
              Text(
                '${_contentController.text.length}/500',
                style: AppTypography.bodySmall.copyWith(
                  color: _contentController.text.length > 450
                      ? AppColors.error
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const Divider(height: 1),

          // Hashtags
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: TextField(
              controller: _hashtagsController,
              decoration: InputDecoration(
                hintText: '#MBTI #Personality #Insights',
                border: InputBorder.none,
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.tag,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.outline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Stack(
          children: [
            // Media preview
            SizedBox(
              width: double.infinity,
              height: 200,
              child: _postType == 'video'
                  ? Container(
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_circle_filled,
                              color: AppColors.primary,
                              size: 64,
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              'Video Selected',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Image.file(
                      _selectedMedia!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.surfaceVariant,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: AppColors.textDisabled,
                              size: 64,
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Remove button
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMedia = null;
                    _postType = 'text';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(AppSpacing.full),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.textInverse,
                    size: 16,
                  ),
                ),
              ),
            ),

            // Type indicator
            if (_postType == 'video')
              Positioned(
                bottom: AppSpacing.sm,
                left: AppSpacing.sm,
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
        ),
      ),
    );
  }

  Widget _buildPostOptions() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Post Options',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: _buildOptionCard(
                  icon: Icons.visibility,
                  title: 'Public',
                  subtitle: 'Anyone can see',
                  isSelected: true,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildOptionCard(
                  icon: Icons.comment,
                  title: 'Comments',
                  subtitle: 'Allow comments',
                  isSelected: true,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
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

  Widget _buildMBTIMoodSection() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MBTI Context',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // MBTI Type Selector
          Text(
            'Your MBTI Type',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: _mbtiTypes.map((type) {
              final isSelected = type == _selectedMBTI;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMBTI = type;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.full),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.outline,
                    ),
                  ),
                  child: Text(
                    type,
                    style: AppTypography.bodySmall.copyWith(
                      color: isSelected
                          ? AppColors.textInverse
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.md),

          // Mood Selector
          Text(
            'Current Mood',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: _moods.map((mood) {
              final isSelected = mood == _selectedMood;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = mood;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.diplomat
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.full),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.diplomat
                          : AppColors.outline,
                    ),
                  ),
                  child: Text(
                    mood,
                    style: AppTypography.bodySmall.copyWith(
                      color: isSelected
                          ? AppColors.textInverse
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final File? image = await _mediaService.pickImageFromGallery();
      if (image != null) {
        setState(() {
          _selectedMedia = image;
          _postType = 'image';
        });
      }
    } catch (e) {
      if (e.toString().contains('permission')) {
        _mediaService.showPermissionDeniedDialog(context, 'Gallery');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickVideo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final File? video = await _mediaService.pickVideoFromGallery();
      if (video != null) {
        setState(() {
          _selectedMedia = video;
          _postType = 'video';
        });
      }
    } catch (e) {
      if (e.toString().contains('permission')) {
        _mediaService.showPermissionDeniedDialog(context, 'Gallery');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool get _isFormValid {
    if (_contentController.text.trim().isEmpty) return false;
    if (_contentController.text.length > 500) return false;
    return true;
  }

  void _createPost() {
    if (!_isFormValid) return;

    // Process hashtags
    final List<String> hashtags = [];
    if (_hashtagsController.text.trim().isNotEmpty) {
      final tags = _hashtagsController.text
          .split(' ')
          .where((tag) => tag.trim().isNotEmpty)
          .map((tag) => tag.startsWith('#') ? tag : '#$tag')
          .toList();
      hashtags.addAll(tags);
    }

    // Add default MBTI hashtags if none provided
    if (hashtags.isEmpty) {
      hashtags.addAll(['#$_selectedMBTI', '#MBTI', '#Personality']);
    }

    // Create post data
    final postData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'username': 'You',
      'mbtiType': _selectedMBTI,
      'avatar': '👤',
      'timeAgo': 'Just now',
      'postType': _postType,
      'content': _contentController.text.trim(),
      'likes': 0,
      'comments': 0,
      'shares': 0,
      'hashtags': hashtags,
      'mood': _selectedMood,
      'mediaPath': _selectedMedia?.path,
      'timestamp': DateTime.now(),
    };

    // Show success message
    _mediaService.showSuccessMessage(context, 'Post created successfully! 📝');

    // Return post data
    Navigator.pop(context, postData);
  }
}
