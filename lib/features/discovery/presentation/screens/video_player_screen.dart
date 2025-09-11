import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/core/constants/app_spacing.dart';
import 'package:opop/core/constants/app_typography.dart';
import '../widgets/discovery_comment_drawer.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> videoData;

  const VideoPlayerScreen({
    super.key,
    required this.videoData,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isPlaying = false;
  bool _isControlsVisible = true;
  bool _isLiked = false;
  bool _isBookmarked = false;
  double _progress = 0.0;
  double _volume = 1.0;
  int _likeCount = 0;
  int _commentCount = 0;
  int _shareCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeVideoData();
    _startAutoHideControls();
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

  void _initializeVideoData() {
    _likeCount = widget.videoData['likes'] ?? 0;
    _commentCount = widget.videoData['comments'] ?? 0;
    _shareCount = widget.videoData['shares'] ?? 0;
  }

  void _startAutoHideControls() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        _hideControls();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Video Background
            _buildVideoBackground(),
            
            // Video Controls Overlay
            if (_isControlsVisible) _buildControlsOverlay(),
            
            // Top Bar
            if (_isControlsVisible) _buildTopBar(),
            
            // Bottom Controls
            if (_isControlsVisible) _buildBottomControls(),
            
            // Side Actions
            if (_isControlsVisible) _buildSideActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoBackground() {
    final gradient = widget.videoData['gradient'] as List<Color>;
    
    return Container(
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
              widget.videoData['videoThumbnail'] ?? '🎬',
              style: AppTypography.displayLarge.copyWith(
                fontSize: 120,
                color: AppColors.textInverse.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (!_isPlaying)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.textInverse.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(AppSpacing.full),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: gradient.first,
                  size: AppSpacing.iconSize * 2,
                ),
              ),
          ],
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
              Colors.black.withOpacity(0.7),
            ],
            stops: const [0.0, 0.3, 0.7],
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
                          widget.videoData['username'] ?? 'Unknown User',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textInverse,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          '${widget.videoData['mbtiType'] ?? 'MBTI'} • ${widget.videoData['timeAgo'] ?? '2h ago'}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textInverse.withOpacity(0.8),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
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
                  // Progress Bar
                  _buildProgressBar(),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Video Info
                  _buildVideoInfo(),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Control Buttons
                  _buildControlButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.textInverse.withOpacity(0.3),
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.3),
          ),
          child: Slider(
            value: _progress,
            onChanged: (value) {
              setState(() {
                _progress = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_progress * 154), // 2:34 total duration
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textInverse,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '2:34',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textInverse,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoInfo() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.videoData['content'] ?? 'MBTI Video Content',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textInverse,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${_likeCount} likes • ${_commentCount} comments • ${_shareCount} shares',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textInverse.withOpacity(0.7),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Row(
      children: [
        IconButton(
          onPressed: _togglePlayPause,
          icon: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: AppColors.textInverse,
            size: AppSpacing.iconSize,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.volume_up,
            color: AppColors.textInverse,
            size: AppSpacing.iconSize,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: _toggleLike,
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? AppColors.error : AppColors.textInverse,
            size: AppSpacing.iconSize,
          ),
        ),
        IconButton(
          onPressed: _showComments,
          icon: const Icon(
            Icons.comment,
            color: AppColors.textInverse,
            size: AppSpacing.iconSize,
          ),
        ),
        IconButton(
          onPressed: _shareVideo,
          icon: const Icon(
            Icons.share,
            color: AppColors.textInverse,
            size: AppSpacing.iconSize,
          ),
        ),
        IconButton(
          onPressed: _toggleBookmark,
          icon: Icon(
            _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: _isBookmarked ? AppColors.primary : AppColors.textInverse,
            size: AppSpacing.iconSize,
          ),
        ),
      ],
    );
  }

  Widget _buildSideActions() {
    return Positioned(
      right: AppSpacing.md,
      bottom: 150,
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
            onTap: _shareVideo,
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
    if (_isPlaying && _isControlsVisible) {
      setState(() {
        _isControlsVisible = false;
      });
      _fadeController.reverse();
      _slideController.reverse();
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _startAutoHideControls();
      // Simulate video progress
      _simulateVideoProgress();
    }
  }

  void _simulateVideoProgress() {
    if (_isPlaying && _progress < 1.0) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _isPlaying) {
          setState(() {
            _progress = (_progress + 0.01).clamp(0.0, 1.0);
          });
          _simulateVideoProgress();
        }
      });
    }
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLiked ? 'Video liked! ❤️' : 'Like removed'),
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
        content: Text(_isBookmarked ? 'Video saved! 🔖' : 'Bookmark removed'),
        duration: const Duration(seconds: 1),
        backgroundColor: _isBookmarked ? AppColors.primary : AppColors.textSecondary,
      ),
    );
  }

  void _showComments() {
    _showCommentDrawer();
  }

  void _shareVideo() {
    setState(() {
      _shareCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video shared! 📤'),
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
        contentTitle: widget.videoData['content'] ?? 'Video Comments',
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
        'content': 'This video really resonates with me! I love how you explained the cognitive functions in such a relatable way.',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'likes': 24,
        'isLiked': false,
        'isPinned': true,
        'replies': [
          {
            'userName': 'Alex Kumar',
            'content': 'Totally agree! The explanation was so clear and easy to understand.',
            'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
          },
        ],
      },
      {
        'id': '2',
        'userName': 'Marcus Johnson',
        'mbtiType': 'INTJ',
        'avatar': '🧠',
        'content': 'Great analysis! I\'ve been studying MBTI for years and this is one of the best explanations of Te-Ni-Se-Fi I\'ve seen.',
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
        'content': 'This helped me understand myself so much better! Thank you for sharing your insights.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'likes': 31,
        'isLiked': false,
        'replies': [],
      },
    ];
  }

  String _formatDuration(double seconds) {
    final totalSeconds = seconds.toInt();
    final minutes = totalSeconds ~/ 60;
    final remainingSeconds = totalSeconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}