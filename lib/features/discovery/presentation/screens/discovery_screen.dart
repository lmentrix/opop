import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../matching/presentation/screens/matching_screen.dart';
import '../../../profile/data/models/friend_profile.dart';
import '../../../profile/presentation/screens/friend_profile_screen.dart';
import '../../data/models/discovery_data.dart';
import '../../provider/discovery_provider.dart';
import '../widgets/discovery_comment_drawer.dart';
import 'camera_gallery_capture_screen.dart';
import 'image_viewer_screen.dart';
import 'match_detail_screen.dart';
import 'music_story_creation_screen.dart';
import 'poll_creation_screen.dart';
import 'post_creation_screen.dart';
import 'text_story_creation_screen.dart';
import 'trending_topic_detail_screen.dart';
import 'video_player_screen.dart';

/// Discovery screen for exploring MBTI content
class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  final Map<String, AnimationController> _likeAnimationControllers = {};
  final Map<String, AnimationController> _bookmarkAnimationControllers = {};
  Set<String> deletedStoriesId = {};

  //check if deleted
  bool isDeleted = false;

  @override
  void initState() {
    super.initState();
    // Initialize discovery data through provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DiscoveryProvider>(context, listen: false);
      provider.initializeDiscoveryData();
    });

    // Initialize animation controllers
    _initializeAnimationControllers();
  }

  @override
  void dispose() {
    // Dispose animation controllers
    for (final controller in _likeAnimationControllers.values) {
      controller.dispose();
    }
    for (final controller in _bookmarkAnimationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeAnimationControllers() {
    // Animation controllers will be initialized when posts are loaded
  }

  void _initializePotentialMatches() {
    // Potential matches are now managed by the provider
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [_buildSliverAppBar(), _buildDiscoveryContent()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPost,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textInverse),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.primaryGradient,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Discover',
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'Explore MBTI insights and content',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textInverse.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoveryContent() {
    return SliverToBoxAdapter(
      child: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('MBTI Stories'),
              const SizedBox(height: AppSpacing.md),
              _buildStoriesSection(),
              const SizedBox(height: AppSpacing.xl),
              _buildSectionTitle('Trending Topics'),
              const SizedBox(height: AppSpacing.md),
              _buildTrendingTopics(),
              const SizedBox(height: AppSpacing.xl),
              _buildSectionTitle('MBTI Feed'),
              const SizedBox(height: AppSpacing.md),
              _buildMBTIFeed(context),
              const SizedBox(height: AppSpacing.xl),
              _buildSectionTitle('MBTI Matching'),
              const SizedBox(height: AppSpacing.md),
              _buildMBTIMatching(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.titleLarge.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildStoriesSection() {
    return Consumer<DiscoveryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingStories) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.storiesError != null) {
          return SizedBox(
            height: 120,
            child: Center(
              child: Text(
                'Error loading stories',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          );
        }

        final stories = provider.mbtiStories;

        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return _buildStoryItem(context, story);
            },
          ),
        );
      },
    );
  }

  Widget _buildStoryItem(BuildContext context, Map<String, dynamic> story) {
    final isAddStory = story['id'] == 'add_story';
    final isViewed = story['isViewed'] as bool? ?? false;
    final gradient = _getStoryGradient(story);

    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _onStoryTap(context, story, story['id'] as String),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.full),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isViewed && !isAddStory
                      ? [
                          AppColors.textDisabled,
                          AppColors.textDisabled.withOpacity(0.5),
                        ]
                      : gradient,
                ),
                border: isAddStory
                    ? null
                    : Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: gradient.first.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      story['avatar'] as String,
                      style: AppTypography.titleLarge.copyWith(
                        fontSize: isAddStory ? 24 : 28,
                        color: isAddStory ? AppColors.textInverse : null,
                      ),
                    ),
                  ),
                  if (!isAddStory &&
                      story['storyType'].isNotEmpty &&
                      story['storyType'] != 'image')
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: _buildMediaTypeIndicator(
                        story['storyType'] as String,
                      ),
                    ),
                  if (isViewed && !isAddStory)
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(AppSpacing.full),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            height: 32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  story['username'] as String,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isAddStory &&
                    (story['mbtiType'] as String? ?? '').isNotEmpty)
                  Text(
                    story['mbtiType'] as String,
                    style: AppTypography.labelSmall.copyWith(
                      color: gradient.first,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getStoryGradient(Map<String, dynamic> story) {
    if (story['id'] == 'add_story') {
      return [AppColors.primary, AppColors.primaryLight];
    }

    final mbtiType = story['mbtiType'] as String? ?? '';

    if (mbtiType.isEmpty || mbtiType.length < 2) {
      return [AppColors.primary, AppColors.primaryLight];
    }

    final prefix = mbtiType.substring(0, 2);

    switch (prefix) {
      case 'IN':
        return [AppColors.analyst, AppColors.analyst.withOpacity(0.7)];
      case 'EN':
        if (mbtiType.contains('F')) {
          return [AppColors.diplomat, AppColors.diplomat.withOpacity(0.7)];
        }
        return [AppColors.analyst, AppColors.diplomat];
      case 'IS':
        if (mbtiType.contains('T')) {
          return [AppColors.sentinel, AppColors.sentinel.withOpacity(0.7)];
        }
        return [AppColors.explorer, AppColors.explorer.withOpacity(0.7)];
      case 'ES':
        return [AppColors.explorer, AppColors.explorer.withOpacity(0.7)];
      default:
        return [AppColors.primary, AppColors.primaryLight];
    }
  }

  Widget _buildMediaTypeIndicator(String mediaType) {
    IconData icon;
    Color backgroundColor;

    switch (mediaType) {
      case 'video':
        icon = Icons.play_arrow;
        backgroundColor = AppColors.error;
        break;
      case 'poll':
        icon = Icons.poll;
        backgroundColor = AppColors.info;
        break;
      case 'boomerang':
        icon = Icons.loop;
        backgroundColor = AppColors.warning;
        break;
      case 'music':
        icon = Icons.music_note;
        backgroundColor = AppColors.success;
        break;
      case 'text':
        icon = Icons.text_fields;
        backgroundColor = AppColors.primary;
        break;
      default:
        icon = Icons.photo;
        backgroundColor = AppColors.textSecondary;
    }

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.full),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Icon(icon, color: Colors.white, size: 12),
    );
  }

  void _onStoryTap(
    BuildContext context,
    Map<String, dynamic> story,
    String postId,
  ) {
    if (story['id'] == 'add_story') {
      _showAddStoryOptions(context);
    } else {
      final provider = Provider.of<DiscoveryProvider>(context, listen: false);

      // Check if story still exists
      if (!provider.storyExists(story['id'])) {
        _showEmptyStoryState();
        return;
      }

      if (isDeleted && story['id'] == postId) {
        _showEmptyStoryState();
        return;
      }

      _showStoryViewer(context, story);
    }
  }

  void _createPost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PostCreationScreen()),
    );

    if (result.isNotEmpty) {
      _addNewPost(result as Map<String, dynamic>);
    }
  }

  void _addNewPost(Map<String, dynamic> newPost) {
    final provider = Provider.of<DiscoveryProvider>(context, listen: false);

    setState(() {
      // Initialize animation controllers for the new post
      final postId = newPost['id'] as String;
      _likeAnimationControllers[postId] = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
      _bookmarkAnimationControllers[postId] = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
    });

    // The provider will handle the post state management
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post added to feed! 📝'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAddStoryOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
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
              Text(
                'Create Your MBTI Story',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildAddStoryOption(
                icon: Icons.camera_alt,
                title: 'Camera',
                subtitle: 'Take a photo',
                color: AppColors.primary,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CameraGalleryCaptureScreen(mediaType: 'camera'),
                    ),
                  );
                },
              ),
              _buildAddStoryOption(
                icon: Icons.photo_library,
                title: 'Gallery',
                subtitle: 'Choose from your photos',
                color: AppColors.analyst,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CameraGalleryCaptureScreen(
                        mediaType: 'gallery',
                      ),
                    ),
                  );
                },
              ),
              _buildAddStoryOption(
                icon: Icons.videocam,
                title: 'Video',
                subtitle: 'Record or choose video',
                color: AppColors.error,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CameraGalleryCaptureScreen(mediaType: 'video'),
                    ),
                  );
                },
              ),
              _buildAddStoryOption(
                icon: Icons.text_fields,
                title: 'Text Story',
                subtitle: 'Share your MBTI thoughts',
                color: AppColors.diplomat,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TextStoryCreationScreen(),
                    ),
                  );
                },
              ),
              _buildAddStoryOption(
                icon: Icons.poll,
                title: 'Poll',
                subtitle: 'Ask your followers',
                color: AppColors.sentinel,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PollCreationScreen(),
                    ),
                  );
                },
              ),
              _buildAddStoryOption(
                icon: Icons.music_note,
                title: 'Music',
                subtitle: 'Add music to your story',
                color: AppColors.explorer,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MusicStoryCreationScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddStoryOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Icon(icon, color: color, size: AppSpacing.iconSize),
      ),
      title: Text(
        title,
        style: AppTypography.titleMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 0.2,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textSecondary,
        size: AppSpacing.iconSize * 0.8,
      ),
      onTap: onTap,
    );
  }

  void _showStoryViewer(BuildContext context, Map<String, dynamic> story) {
    // Get fresh story data from provider
    final provider = Provider.of<DiscoveryProvider>(context, listen: false);

    // Check if story still exists
    if (!provider.storyExists(story['id'])) {
      _showEmptyStoryState();
      return;
    }

    // Get fresh story data
    final freshStory = provider.mbtiStories.firstWhere(
      (s) => s['id'] == story['id'],
      orElse: () => story,
    );

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 400,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors:
                            (freshStory['gradient'] as List<Color>?) ??
                            [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.lg),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          freshStory['avatar'] as String,
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 80,
                            color: AppColors.textInverse,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          '${freshStory['mbtiType']} Story',
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.textInverse,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textInverse.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.full,
                            ),
                          ),
                          child: Text(
                            _getStoryContent(
                              freshStory['storyType']?.toString() ?? 'image',
                            ),
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textInverse,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.textInverse,
                    child: Text(
                      freshStory['avatar'] as String,
                      style: AppTypography.titleMedium.copyWith(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          freshStory['username'] as String,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textInverse,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '${freshStory['mbtiType']} • ${freshStory['timeAgo']}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textInverse.withOpacity(0.8),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textInverse,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textInverse.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.full),
                        border: Border.all(
                          color: AppColors.textInverse.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'Reply to story...',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textInverse.withOpacity(0.7),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border,
                      color: AppColors.textInverse,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      color: AppColors.textInverse,
                      size: 28,
                    ),
                  ),
                  // Add delete button for user's own stories
                  if (freshStory['username'] == 'You')
                    IconButton(
                      onPressed: () => _deleteStory(freshStory),
                      icon: const Icon(
                        Icons.delete,
                        color: AppColors.error,
                        size: 28,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStoryContent(String mediaType) {
    switch (mediaType) {
      case 'video':
        return 'Watch my MBTI journey unfold! 🎬';
      case 'poll':
        return 'What\'s your biggest MBTI strength? Vote now! 📊';
      case 'boomerang':
        return 'Expressing my personality in motion! 🔄';
      case 'music':
        return 'This song perfectly captures my MBTI vibe 🎵';
      case 'text':
        return 'Just discovered something amazing about my personality type!';
      case 'image':
      default:
        return 'Sharing a moment from my MBTI exploration 📸';
    }
  }

  Widget _buildMBTIFeed(BuildContext context) {
    return Consumer<DiscoveryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingPosts) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading posts...'),
              ],
            ),
          );
        }

        if (provider.postsError != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: AppColors.error),
                SizedBox(height: 16),
                Text(
                  'Error loading posts',
                  style: TextStyle(color: AppColors.error),
                ),
              ],
            ),
          );
        }

        final posts = provider.posts;

        if (posts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.feed_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No posts available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          children: posts
              .map((post) => _buildFeedPost(context, post.toJson()))
              .toList(),
        );
      },
    );
  }

  Widget _buildFeedPost(BuildContext context, Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(context, post),
          _buildPostContent(context, post),
          _buildPostHashtags(post),
          _buildPostActions(post),
        ],
      ),
    );
  }

  Widget _buildPostHeader(BuildContext context, Map<String, dynamic> post) {
    final gradient =
        (post['gradient'] as List<Color>?) ??
        [AppColors.primary, AppColors.primaryLight];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: GestureDetector(
        onTap: () => _onProfilePictureTap(context, post),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.full),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  post['avatar'] as String,
                  style: AppTypography.titleMedium.copyWith(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        post['username'] as String,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: gradient.first.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppSpacing.xs),
                        ),
                        child: Text(
                          post['mbtiType'] as String,
                          style: AppTypography.labelSmall.copyWith(
                            color: gradient.first,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    post['timeAgo'] as String,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showPostOptions(context, post),
              icon: Icon(
                Icons.more_horiz,
                color: AppColors.textSecondary,
                size: AppSpacing.iconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostContent(BuildContext context, Map<String, dynamic> post) {
    final postType = post['postType'] as String;
    final gradient =
        (post['gradient'] as List<Color>?) ??
        [AppColors.primary, AppColors.primaryLight];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (postType == 'video')
          _buildVideoContent(context, post, gradient)
        else if (postType == 'image')
          _buildImageContent(context, post, gradient)
        else
          _buildTextContent(post),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            post['content'] as String,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoContent(
    BuildContext context,
    Map<String, dynamic> post,
    List<Color> gradient,
  ) {
    return GestureDetector(
      onTap: () => _playVideo(context, post),
      child: Container(
        width: double.infinity,
        height: 250,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              post['videoThumbnail'] as String,
              style: AppTypography.displayLarge.copyWith(
                fontSize: 80,
                color: AppColors.textInverse.withOpacity(0.3),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.textInverse.withOpacity(0.9),
                borderRadius: BorderRadius.circular(AppSpacing.full),
              ),
              child: Icon(
                Icons.play_arrow,
                color: gradient.first,
                size: AppSpacing.iconSize * 1.5,
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
                child: Text(
                  '2:34',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent(
    BuildContext context,
    Map<String, dynamic> post,
    List<Color> gradient,
  ) {
    return GestureDetector(
      onTap: () => _viewImage(context, post),
      child: Container(
        height: 250,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                post['imageThumbnail'] as String,
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 80,
                  color: AppColors.textInverse,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Tap to view',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textInverse.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(
          color:
              ((post['gradient'] as List<Color>?) ??
                      [AppColors.primary, AppColors.primaryLight])
                  .first
                  .withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color:
                  ((post['gradient'] as List<Color>?) ??
                          [AppColors.primary, AppColors.primaryLight])
                      .first
                      .withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Icon(
              Icons.format_quote,
              color:
                  ((post['gradient'] as List<Color>?) ??
                          [AppColors.primary, AppColors.primaryLight])
                      .first,
              size: AppSpacing.iconSize,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Tap to read full post',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostHashtags(Map<String, dynamic> post) {
    final hashtags = post['hashtags'] as List<String>;
    final gradient =
        (post['gradient'] as List<Color>?) ??
        [AppColors.primary, AppColors.primaryLight];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: hashtags.map((hashtag) {
          return GestureDetector(
            onTap: () => _searchHashtag(hashtag),
            child: Text(
              hashtag,
              style: AppTypography.bodySmall.copyWith(
                color: gradient.first,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPostActions(Map<String, dynamic> post) {
    return Consumer<DiscoveryProvider>(
      builder: (context, provider, child) {
        final postId = post['id'] as String;
        final likeCount = provider.getPostLikeCount(postId);
        final commentCount = provider.getPostCommentCount(postId);
        final shareCount = provider.getPostShareCount(postId);

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              _buildAnimatedLikeButton(postId, likeCount, provider),
              const SizedBox(width: AppSpacing.lg),
              _buildActionButton(
                icon: Icons.chat_bubble_outline,
                count: commentCount,
                onTap: () => _commentOnPost(postId),
              ),
              const SizedBox(width: AppSpacing.lg),
              _buildActionButton(
                icon: Icons.share_outlined,
                count: shareCount,
                onTap: () => _sharePostById(postId),
              ),
              const Spacer(),
              _buildAnimatedBookmarkButton(postId, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
    bool isActive = false,
    Color? activeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: isActive
                ? activeColor ?? AppColors.primary
                : AppColors.textSecondary,
            size: AppSpacing.iconSize,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            count.toString(),
            style: AppTypography.bodySmall.copyWith(
              color: isActive
                  ? activeColor ?? AppColors.primary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLikeButton(
    String postId,
    int count,
    DiscoveryProvider provider,
  ) {
    final isLiked = provider.isPostLiked(postId);
    final controller =
        _likeAnimationControllers[postId] ??
        AnimationController(
          duration: const Duration(milliseconds: 400),
          vsync: this,
        );

    // Initialize controller if not exists
    if (!_likeAnimationControllers.containsKey(postId)) {
      _likeAnimationControllers[postId] = controller;
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = 1.0 + (controller.value * 0.3);
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: () => _toggleLike(postId, provider),
            child: Row(
              children: [
                Stack(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked
                          ? AppColors.error
                          : AppColors.textSecondary,
                      size: AppSpacing.iconSize,
                    ),
                    if (controller.isAnimating)
                      Positioned.fill(
                        child: Icon(
                          Icons.favorite,
                          color: AppColors.error.withOpacity(controller.value),
                          size:
                              AppSpacing.iconSize *
                              (1.0 + controller.value * 0.5),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  count.toString(),
                  style: AppTypography.bodySmall.copyWith(
                    color: isLiked ? AppColors.error : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBookmarkButton(
    String postId,
    DiscoveryProvider provider,
  ) {
    final isBookmarked = provider.isPostBookmarked(postId);
    final controller =
        _bookmarkAnimationControllers[postId] ??
        AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        );

    // Initialize controller if not exists
    if (!_bookmarkAnimationControllers.containsKey(postId)) {
      _bookmarkAnimationControllers[postId] = controller;
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final rotation = controller.value * 0.2;
        return Transform.rotate(
          angle: rotation,
          child: IconButton(
            onPressed: () => _toggleBookmark(postId, provider),
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? AppColors.primary : AppColors.textSecondary,
              size: AppSpacing.iconSize,
            ),
          ),
        );
      },
    );
  }

  // Action methods
  void _onProfilePictureTap(BuildContext context, Map<String, dynamic> post) {
    // Create FriendProfile from post data
    final friendProfile = FriendProfile(
      id: 'friend_${post['id']}',
      name: post['username'] as String,
      avatar: post['avatar'] as String,
      mbtiType: post['mbtiType'] as String,
      status: 'Active',
      conversationCount: 0,
    );

    // Navigate to friend profile screen with MBTI feed data
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FriendProfileScreen(friendProfile: friendProfile),
      ),
    );
  }

  void _showPostOptions(BuildContext context, Map<String, dynamic> post) {
    final isCurrentUser =
        post['username'] == 'You'; // Check if it's current user's post
    final provider = Provider.of<DiscoveryProvider>(context, listen: false);
    final isLiked = provider.isPostLiked(post['id'] as String);
    final isBookmarked = provider.isPostBookmarked(post['id'] as String);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.lg),
            topRight: Radius.circular(AppSpacing.lg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Post header
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors:
                            (post['gradient'] as List<Color>?) ??
                            [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.full),
                    ),
                    child: Center(
                      child: Text(
                        post['avatar'] as String,
                        style: AppTypography.titleMedium.copyWith(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['username'] as String,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          post['timeAgo'] as String,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: AppColors.outline.withOpacity(0.2)),

            // Options
            ..._buildPostOptionItems(
              context,
              post,
              isCurrentUser,
              isLiked,
              isBookmarked,
            ),

            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPostOptionItems(
    BuildContext context,
    Map<String, dynamic> post,
    bool isCurrentUser,
    bool isLiked,
    bool isBookmarked,
  ) {
    final options = <Widget>[];

    // Like/Unlike option
    options.add(
      ListTile(
        leading: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? AppColors.error : AppColors.textSecondary,
        ),
        title: Text(isLiked ? 'Unlike Post' : 'Like Post'),
        onTap: () {
          Navigator.pop(context);
          final provider = Provider.of<DiscoveryProvider>(
            context,
            listen: false,
          );
          _toggleLike(post['id'] as String, provider);
        },
      ),
    );

    // Bookmark option
    options.add(
      ListTile(
        leading: Icon(
          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          color: isBookmarked ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(isBookmarked ? 'Remove Bookmark' : 'Bookmark Post'),
        onTap: () {
          Navigator.pop(context);
          final provider = Provider.of<DiscoveryProvider>(
            context,
            listen: false,
          );
          _toggleBookmark(post['id'] as String, provider);
        },
      ),
    );

    // Share option
    options.add(
      ListTile(
        leading: Icon(Icons.share, color: AppColors.textSecondary),
        title: Text('Share Post'),
        onTap: () {
          Navigator.pop(context);
          _sharePost(context, post);
        },
      ),
    );

    // View post details
    options.add(
      ListTile(
        leading: Icon(Icons.visibility, color: AppColors.textSecondary),
        title: Text('View Post Details'),
        onTap: () {
          Navigator.pop(context);
          _viewPostDetails(context, post);
        },
      ),
    );

    // Copy link option
    options.add(
      ListTile(
        leading: Icon(Icons.link, color: AppColors.textSecondary),
        title: Text('Copy Link'),
        onTap: () {
          Navigator.pop(context);
          _copyPostLink(context, post);
        },
      ),
    );

    // Report post (only for other users' posts)
    if (!isCurrentUser) {
      options.add(
        ListTile(
          leading: Icon(Icons.flag, color: AppColors.error),
          title: Text('Report Post', style: TextStyle(color: AppColors.error)),
          onTap: () {
            Navigator.pop(context);
            _reportPost(context, post);
          },
        ),
      );
    }

    // TODO: delete only current user

    options.add(
      Expanded(
        flex: 4,
        child: ListTile(
          leading: Icon(Icons.delete, color: AppColors.error),
          title: Text('Delete Post', style: TextStyle(color: AppColors.error)),
          onTap: () {
            Navigator.pop(context);
            _deletePost(context, post);
          },
        ),
      ),
    );

    return options;
  }

  // Post option methods
  void _toggleLike(String postId, DiscoveryProvider provider) {
    provider.toggleLikePost(postId);

    // Trigger like animation
    _likeAnimationControllers[postId]?.forward().then((_) {
      _likeAnimationControllers[postId]?.reverse();
    });
  }

  void _toggleBookmark(String postId, DiscoveryProvider provider) {
    provider.toggleBookmarkPost(postId);

    // Trigger bookmark animation
    _bookmarkAnimationControllers[postId]?.forward().then((_) {
      _bookmarkAnimationControllers[postId]?.reverse();
    });
  }

  void _sharePost(BuildContext context, Map<String, dynamic> post) {
    // Show share options
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.lg),
            topRight: Radius.circular(AppSpacing.lg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Share Post',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message, color: AppColors.primary),
              title: Text('Share in Message'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Post shared in message'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.group, color: AppColors.diplomat),
              title: Text('Share to Group'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Post shared to group'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.public, color: AppColors.explorer),
              title: Text('Share to Profile'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Post shared to profile'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _viewPostDetails(BuildContext context, Map<String, dynamic> post) {
    // Show post details dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Post Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Author: ${post['username']}'),
            Text('MBTI Type: ${post['mbtiType']}'),
            Text('Posted: ${post['timeAgo']}'),
            Text('Type: ${post['postType']}'),
            SizedBox(height: AppSpacing.md),
            Text('Content:'),
            Text(post['content']),
            SizedBox(height: AppSpacing.md),
            Text('Hashtags: ${(post['hashtags'] as List).join(', ')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _copyPostLink(BuildContext context, Map<String, dynamic> post) {
    // Simulate copying link to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post link copied to clipboard'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _reportPost(BuildContext context, Map<String, dynamic> post) {
    // Show report dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Why are you reporting this post?'),
            SizedBox(height: AppSpacing.md),
            ...[
                  'Spam',
                  'Inappropriate Content',
                  'Harassment',
                  'False Information',
                  'Other',
                ]
                .map(
                  (reason) => ListTile(
                    title: Text(reason),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Post reported for: $reason'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deletePost(BuildContext context, Map<String, dynamic> post) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performDeletePost(post);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _performDeletePost(Map<String, dynamic> post) {
    final provider = Provider.of<DiscoveryProvider>(context, listen: false);
    final postId = post['id'] as String;
    final deletedStoryId = post['storyId'] as String?;

    // Delete the post
    provider.deletePost(postId);

    // Clean up animation controllers
    setState(() {
      _likeAnimationControllers[postId]?.dispose();
      _likeAnimationControllers.remove(postId);
      _bookmarkAnimationControllers[postId]?.dispose();
      _bookmarkAnimationControllers.remove(postId);
      isDeleted = !isDeleted;
      deletedStoriesId.add(deletedStoryId ?? '');
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post deleted successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _playVideo(BuildContext context, Map<String, dynamic> post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoData: post),
      ),
    );
  }

  void _viewImage(BuildContext context, Map<String, dynamic> post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageViewerScreen(imageData: post),
      ),
    );
  }

  void _searchHashtag(String hashtag) {
    // TODO: Implement hashtag search
    print('Searching for $hashtag');
  }

  void _commentOnPost(String postId) {
    _showCommentDrawer(context, postId);
  }

  void _sharePostById(String postId) {
    final provider = Provider.of<DiscoveryProvider>(context, listen: false);
    final post = provider.posts.firstWhere(
      (p) => p.id == postId,
      orElse: () => DiscoveryPost.empty(),
    );
    if (post.id.isNotEmpty) {
      _sharePost(context, post.toJson());
    }
  }

  void _showCommentDrawer(BuildContext context, String postId) {
    // Get post data for the comment drawer
    final postData = _getPostData(postId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DiscoveryCommentDrawer(
        contentTitle: postData['title'] ?? 'Post Comments',
        initialComments: _createDummyComments(),
        onCommentAdded: (comment) {
          final provider = Provider.of<DiscoveryProvider>(
            context,
            listen: false,
          );
          setState(() {
            // Comment counts are managed by the provider
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

  Map<String, dynamic> _getPostData(String postId) {
    // Return post data based on post ID
    final posts = {
      '1': {'title': 'Cognitive Functions Discovery'},
      '2': {'title': 'ENFP Ideas & Focus'},
      '3': {'title': 'Productivity Morning Routine'},
      '4': {'title': 'Fi-Se Art Journey'},
      '5': {'title': 'MBTI Philosophy Hot Take'},
    };

    return posts[postId] ?? {'title': 'Post Comments'};
  }

  List<Map<String, dynamic>> _createDummyComments() {
    return [
      {
        'id': '1',
        'userName': 'Sarah Chen',
        'mbtiType': 'ENFP',
        'avatar': '🦋',
        'content':
            'This is so insightful! I\'ve been thinking about how MBTI types approach problem-solving differently. As an ENFP, I definitely see patterns in how I brainstorm versus my INTJ friends.',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'likes': 24,
        'isLiked': false,
        'isPinned': true,
        'replies': [
          {
            'userName': 'Alex Kumar',
            'content':
                'Totally agree! The way different types process information is fascinating.',
            'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
          },
          {
            'userName': 'Maya Patel',
            'content': 'Same here! ENFPs are such great brainstormers',
            'timestamp': DateTime.now().subtract(const Duration(minutes: 8)),
          },
        ],
      },
      {
        'id': '2',
        'userName': 'Marcus Johnson',
        'mbtiType': 'INTJ',
        'avatar': '🧠',
        'content':
            'From a strategic perspective, the analysis here is quite thorough. However, I\'d like to see more data-driven insights about the correlation between cognitive functions and decision-making patterns.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'likes': 18,
        'isLiked': true,
        'replies': [
          {
            'userName': 'Dr. Lisa Wong',
            'content':
                'Excellent point, Marcus. We\'re currently working on a study about this exact correlation.',
            'timestamp': DateTime.now().subtract(const Duration(minutes: 45)),
          },
        ],
      },
      {
        'id': '3',
        'userName': 'Elena Rodriguez',
        'mbtiType': 'INFJ',
        'avatar': '🌟',
        'content':
            'This really resonates with me on a deep level. The way it describes the intuitive process feels so accurate. I often find myself understanding patterns before I can explain them logically.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'likes': 31,
        'isLiked': false,
        'replies': [],
      },
    ];
  }

  void _showShareDialog(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
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
              Text(
                'Share Post',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildShareOption(
                icon: Icons.link,
                title: 'Copy Link',
                onTap: () {
                  Navigator.pop(context);
                  _copyLink(postId);
                },
              ),
              _buildShareOption(
                icon: Icons.message,
                title: 'Share to Chat',
                onTap: () {
                  Navigator.pop(context);
                  _shareToChat(postId);
                },
              ),
              _buildShareOption(
                icon: Icons.share,
                title: 'More Options',
                onTap: () {
                  Navigator.pop(context);
                  _shareExternal(postId);
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: AppTypography.titleMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textSecondary,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _copyLink(String postId) {
    setState(() {
      // Share counts are managed by the provider
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard! 🔗'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _shareToChat(String postId) {
    setState(() {
      // Share counts are managed by the provider
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Shared to chat! 💬'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _shareExternal(String postId) {
    setState(() {
      // Share counts are managed by the provider
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Shared successfully! 📤'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget _buildTrendingTopics() {
    final topics = [
      {'title': 'INTJ vs INTJ', 'color': AppColors.analyst, 'icon': '🧠'},
      {
        'title': 'ENFP Relationships',
        'color': AppColors.diplomat,
        'icon': '💕',
      },
      {'title': 'ISTJ at Work', 'color': AppColors.sentinel, 'icon': '💼'},
      {'title': 'ESFP Adventures', 'color': AppColors.explorer, 'icon': '🌟'},
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return GestureDetector(
            onTap: () => _navigateToTopicDetail(context, topic),
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: AppSpacing.md),
              decoration: BoxDecoration(
                color: topic['color'] as Color,
                borderRadius: BorderRadius.circular(AppSpacing.md),
                boxShadow: [
                  BoxShadow(
                    color: (topic['color'] as Color).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic['icon'] as String,
                      style: AppTypography.titleLarge.copyWith(fontSize: 32),
                    ),
                    const Spacer(),
                    Text(
                      topic['title'] as String,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textInverse,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMBTIMatching(BuildContext context) {
    return Consumer<DiscoveryProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.favorite,
                    color: AppColors.textInverse,
                    size: AppSpacing.iconSize * 2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Find Your MBTI Match',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textInverse,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Connect with people who complement your personality',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textInverse.withOpacity(0.9),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () => _navigateToMatching(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textInverse,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.full),
                      ),
                    ),
                    child: Text(
                      'Start Matching',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Potential Matches',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (provider.isLoadingMatches)
              const Center(child: CircularProgressIndicator())
            else if (provider.matchesError != null)
              Center(
                child: Text(
                  'Error loading matches',
                  style: TextStyle(color: AppColors.error),
                ),
              )
            else if (provider.matches.isEmpty)
              const Center(child: Text('No matches available'))
            else
              ...provider.matches.map(
                (match) => _buildMatchCard(context, match.toJson()),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMatchCard(BuildContext context, Map<String, dynamic> match) {
    final gradient =
        (match['gradient'] as List<Color>?) ??
        [AppColors.primary, AppColors.primaryLight];

    return Dismissible(
      key: Key('match_${match['name']}'),
      direction: DismissDirection.horizontal,
      background: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSpacing.lg),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              color: AppColors.textInverse,
              size: AppSpacing.iconSize * 1.5,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'LIKE',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textInverse,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.textSecondary,
          borderRadius: BorderRadius.circular(AppSpacing.lg),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.close,
              color: AppColors.textInverse,
              size: AppSpacing.iconSize * 1.5,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'PASS',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textInverse,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _likeMatch(match['name'] as String);
        } else {
          _passMatch(match['name'] as String);
        }
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MatchDetailScreen(matchData: match),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.lg),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradient,
                        ),
                        borderRadius: BorderRadius.circular(AppSpacing.full),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          match['avatar'] as String,
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(AppSpacing.xs),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          '${match['compatibility']}%',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textInverse,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            match['name'] as String,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: gradient.first.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.xs,
                              ),
                            ),
                            child: Text(
                              match['mbtiType'] as String,
                              style: AppTypography.labelSmall.copyWith(
                                color: gradient.first,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        match['distance'] as String,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        match['description'] as String,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.xs,
                        children: (match['interests'] as List<String>).map((
                          interest,
                        ) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: gradient.first.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.full,
                              ),
                            ),
                            child: Text(
                              interest,
                              style: AppTypography.labelSmall.copyWith(
                                color: gradient.first,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _likeMatch(match['name'] as String),
                      icon: Icon(
                        Icons.favorite_border,
                        color: AppColors.error,
                        size: AppSpacing.iconSize,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _passMatch(match['name'] as String),
                      icon: Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
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
    );
  }

  void _navigateToTopicDetail(
    BuildContext context,
    Map<String, dynamic> topic,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrendingTopicDetailScreen(topic: topic),
      ),
    );
  }

  void _navigateToMatching(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const MatchingScreen()));
  }

  void _likeMatch(String name) {
    final provider = Provider.of<DiscoveryProvider>(context, listen: false);
    setState(() {
      // Matches are managed by the provider
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liked $name! ❤️'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
      ),
    );
  }

  void _passMatch(String name) {
    final provider = Provider.of<DiscoveryProvider>(context, listen: false);
    setState(() {
      // Matches are managed by the provider
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Passed on $name'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.textSecondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
      ),
    );
  }

  void _showEmptyStoryState() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete_outline,
                    color: AppColors.textSecondary,
                    size: 80,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Story Deleted',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'This story has been removed by the user.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 50,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: AppColors.textPrimary,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteStory(Map<String, dynamic> story) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Story'),
        content: Text(
          'Are you sure you want to delete your story? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performDeleteStory(story);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _performDeleteStory(Map<String, dynamic> story) {
    final provider = Provider.of<DiscoveryProvider>(context, listen: false);
    final storyId = story['id'] as String;

    // Delete the story through provider
    provider.deleteStory(storyId);

    // Close the story viewer
    Navigator.pop(context);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Story deleted successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
