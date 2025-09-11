import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/core/constants/app_spacing.dart';
import 'package:opop/core/constants/app_typography.dart';
import '../widgets/discovery_comment_drawer.dart';

class ImageViewerScreen extends StatefulWidget {
  final Map<String, dynamic> imageData;

  const ImageViewerScreen({
    super.key,
    required this.imageData,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen>
    with TickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isControlsVisible = true;
  bool _isLiked = false;
  bool _isBookmarked = false;
  int _likeCount = 0;
  int _commentCount = 0;
  int _shareCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeImageData();
    _startAutoHideControls();
    
    _transformationController = TransformationController();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  void _initializeImageData() {
    _likeCount = widget.imageData['likes'] ?? 0;
    _commentCount = widget.imageData['comments'] ?? 0;
    _shareCount = widget.imageData['shares'] ?? 0;
  }

  void _startAutoHideControls() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _hideControls();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        onDoubleTap: _resetZoom,
        child: Stack(
          children: [
            // Interactive Image Background
            _buildInteractiveImage(),
            
            // Controls Overlay
            if (_isControlsVisible) _buildControlsOverlay(),
            
            // Top Bar
            if (_isControlsVisible) _buildTopBar(),
            
            // Bottom Info Panel
            if (_isControlsVisible) _buildBottomInfo(),
            
            // Side Actions
            if (_isControlsVisible) _buildSideActions(),
            
            // Zoom Indicator
            if (_isControlsVisible) _buildZoomIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveImage() {
    final gradient = widget.imageData['gradient'] as List<Color>;
    
    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 1.0,
      maxScale: 4.0,
      onInteractionEnd: (details) {
        // Show controls briefly after interaction
        if (!_isControlsVisible) {
          setState(() {
            _isControlsVisible = true;
          });
          _fadeController.forward();
          _slideController.forward();
          _startAutoHideControls();
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.imageData['imageThumbnail'] ?? '🖼️',
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 200,
                  color: AppColors.textInverse.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.textInverse.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Text(
                  'Double tap to reset zoom',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
            stops: const [0.0, 0.2, 0.8, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textInverse,
                      size: AppSpacing.iconSize,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.imageData['username'] ?? 'Unknown User',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textInverse,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          '${widget.imageData['mbtiType'] ?? 'MBTI'} • ${widget.imageData['timeAgo'] ?? '2h ago'}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textInverse.withOpacity(0.8),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _downloadImage,
                        icon: const Icon(
                          Icons.download,
                          color: AppColors.textInverse,
                          size: AppSpacing.iconSize,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert,
                          color: AppColors.textInverse,
                          size: AppSpacing.iconSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  // Image Info
                  _buildImageInfo(),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Hashtags
                  _buildHashtags(),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Engagement Stats
                  _buildEngagementStats(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageInfo() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.imageData['content'] ?? 'MBTI Image Content',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textInverse,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHashtags() {
    final hashtags = widget.imageData['hashtags'] as List<String>? ?? [];
    final gradient = widget.imageData['gradient'] as List<Color>;

    if (hashtags.isEmpty) return const SizedBox();

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: hashtags.map((hashtag) {
        return GestureDetector(
          onTap: () => _searchHashtag(hashtag),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: gradient.first.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSpacing.full),
            ),
            child: Text(
              hashtag,
              style: AppTypography.bodySmall.copyWith(
                color: gradient.first,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEngagementStats() {
    return Row(
      children: [
        Text(
          '${_likeCount} likes',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textInverse,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          '${_commentCount} comments',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textInverse,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          '${_shareCount} shares',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textInverse,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSideActions() {
    return Positioned(
      right: AppSpacing.md,
      bottom: 200,
      child: Column(
        children: [
          _buildSideActionButton(
            icon: Icons.favorite,
            count: _likeCount,
            isActive: _isLiked,
            activeColor: AppColors.error,
            onTap: _toggleLike,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSideActionButton(
            icon: Icons.comment,
            count: _commentCount,
            onTap: _showComments,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSideActionButton(
            icon: Icons.share,
            count: _shareCount,
            onTap: _shareImage,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSideActionButton(
            icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            isActive: _isBookmarked,
            activeColor: AppColors.primary,
            onTap: _toggleBookmark,
          ),
        ],
      ),
    );
  }

  Widget _buildSideActionButton({
    required IconData icon,
    int? count,
    bool isActive = false,
    Color? activeColor,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.textInverse.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSpacing.full),
              border: isActive
                  ? Border.all(color: activeColor ?? AppColors.primary, width: 2)
                  : null,
            ),
            child: Icon(
              icon,
              color: isActive ? activeColor ?? AppColors.primary : AppColors.textInverse,
              size: AppSpacing.iconSize,
            ),
          ),
        ),
        if (count != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            count.toString(),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textInverse,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildZoomIndicator() {
    return Positioned(
      top: 100,
      right: AppSpacing.md,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.textInverse.withOpacity(0.8),
            borderRadius: BorderRadius.circular(AppSpacing.full),
          ),
          child: Text(
            '${(_transformationController.value.getMaxScaleOnAxis()).toStringAsFixed(1)}x',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _toggleControls() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });

    if (_isControlsVisible) {
      _fadeController.forward();
      _slideController.forward();
      _startAutoHideControls();
    } else {
      _fadeController.reverse();
      _slideController.reverse();
    }
  }

  void _hideControls() {
    if (_isControlsVisible) {
      setState(() {
        _isControlsVisible = false;
      });
      _fadeController.reverse();
      _slideController.reverse();
    }
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Zoom reset'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLiked ? 'Image liked! ❤️' : 'Like removed'),
        duration: const Duration(seconds: 1),
        backgroundColor: _isLiked ? AppColors.error : AppColors.textSecondary,
      ),
    );
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? 'Image saved! 🔖' : 'Bookmark removed'),
        duration: const Duration(seconds: 1),
        backgroundColor: _isBookmarked ? AppColors.primary : AppColors.textSecondary,
      ),
    );
  }

  void _showComments() {
    _showCommentDrawer();
  }

  void _shareImage() {
    setState(() {
      _shareCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image shared! 📤'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _downloadImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image downloaded! 📥'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _searchHashtag(String hashtag) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching for $hashtag...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showCommentDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DiscoveryCommentDrawer(
        contentTitle: widget.imageData['content'] ?? 'Image Comments',
        initialComments: _createDummyComments(),
        onCommentAdded: (comment) {
          setState(() {
            _commentCount++;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment added! 💬'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        onCommentLiked: (comment) {
          // Handle comment likes if needed
        },
      ),
    );
  }

  List<Map<String, dynamic>> _createDummyComments() {
    return [
      {
        'id': '1',
        'userName': 'Sarah Chen',
        'mbtiType': 'ENFP',
        'avatar': '🦋',
        'content': 'This artwork is beautiful! The colors really capture the essence of the Fi-Se creative process.',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'likes': 24,
        'isLiked': false,
        'isPinned': true,
        'replies': [
          {
            'userName': 'Alex Kumar',
            'content': 'I love how you used the colors to represent different emotions!',
            'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
          },
        ],
      },
      {
        'id': '2',
        'userName': 'Marcus Johnson',
        'mbtiType': 'INTJ',
        'avatar': '🧠',
        'content': 'Fascinating interpretation of the cognitive functions through visual art. The symbolism is quite profound.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'likes': 18,
        'isLiked': true,
        'replies': [],
      },
      {
        'id': '3',
        'userName': 'Elena Rodriguez',
        'mbtiType': 'INFJ',
        'avatar': '🌟',
        'content': 'This speaks to my soul! I can feel the meaning behind every brush stroke.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'likes': 31,
        'isLiked': false,
        'replies': [],
      },
    ];
  }
}