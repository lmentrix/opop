import 'package:flutter/material.dart';
import 'package:opop/features/discovery/data/models/discovery_data.dart';
import 'package:opop/features/discovery/data/models/music_data.dart';
import 'package:opop/features/discovery/data/models/text_story_data.dart';

class DiscoveryProvider extends ChangeNotifier {
  // Posts state
  List<DiscoveryPost> _posts = [];
  bool _isLoadingPosts = false;
  String? _postsError;

  // Matches state
  List<DiscoveryMatch> _matches = [];
  bool _isLoadingMatches = false;
  String? _matchesError;

  // Music data state
  List<MusicSong> _recommendedSongs = [];
  List<MusicSong> _filteredSongs = [];
  bool _isLoadingMusic = false;
  String? _musicError;

  // Stories state
  List<Map<String, dynamic>> _mbtiStories = [];
  bool _isLoadingStories = false;
  String? _storiesError;

  // Create story state
  bool _isCreatingStory = false;
  String? _createStoryError;
  Map<String, dynamic>? _lastCreatedStory;

  // User interactions state
  final Set<String> _likedPostIds = {};
  final Set<String> _bookmarkedPostIds = {};
  final Map<String, int> _postLikeCounts = {};
  final Map<String, int> _postCommentCounts = {};
  final Map<String, int> _postShareCounts = {};

  // Getters
  List<DiscoveryPost> get posts => _posts;
  bool get isLoadingPosts => _isLoadingPosts;
  String? get postsError => _postsError;

  List<DiscoveryMatch> get matches => _matches;
  bool get isLoadingMatches => _isLoadingMatches;
  String? get matchesError => _matchesError;

  List<MusicSong> get recommendedSongs => _recommendedSongs;
  List<MusicSong> get filteredSongs => _filteredSongs;
  bool get isLoadingMusic => _isLoadingMusic;
  String? get musicError => _musicError;

  List<Map<String, dynamic>> get mbtiStories => _mbtiStories;
  bool get isLoadingStories => _isLoadingStories;
  String? get storiesError => _storiesError;

  bool get isCreatingStory => _isCreatingStory;
  String? get createStoryError => _createStoryError;
  Map<String, dynamic>? get lastCreatedStory => _lastCreatedStory;

  Set<String> get likedPostIds => _likedPostIds;
  Set<String> get bookmarkedPostIds => _bookmarkedPostIds;

  // Initialize discovery data
  Future<void> initializeDiscoveryData() async {
    await Future.wait([
      _loadPosts(),
      _loadMatches(),
      _loadMusicData(),
      _loadStories(),
    ]);
  }

  // Load posts data
  Future<void> _loadPosts() async {
    _isLoadingPosts = true;
    _postsError = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Use data model instead of hardcoded data
      _posts = DiscoveryData.getDummyPosts();

      // Initialize interaction states
      for (final post in _posts) {
        _postLikeCounts[post.id] = post.likes;
        _postCommentCounts[post.id] = post.comments;
        _postShareCounts[post.id] = post.shares;
      }

      _isLoadingPosts = false;
      notifyListeners();
    } catch (e) {
      _postsError = 'Failed to load posts: $e';
      _isLoadingPosts = false;
      notifyListeners();
    }
  }

  // Load matches data
  Future<void> _loadMatches() async {
    _isLoadingMatches = true;
    _matchesError = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Use data model instead of hardcoded data
      _matches = DiscoveryData.getDummyMatches();

      _isLoadingMatches = false;
      notifyListeners();
    } catch (e) {
      _matchesError = 'Failed to load matches: $e';
      _isLoadingMatches = false;
      notifyListeners();
    }
  }

  // Load music data
  Future<void> _loadMusicData() async {
    _isLoadingMusic = true;
    _musicError = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 400));

      // Use data model instead of hardcoded data
      _recommendedSongs = MusicData.getRecommendedSongs();
      _filteredSongs = List.from(_recommendedSongs);

      _isLoadingMusic = false;
      notifyListeners();
    } catch (e) {
      _musicError = 'Failed to load music data: $e';
      _isLoadingMusic = false;
      notifyListeners();
    }
  }

  // Post interactions
  void toggleLikePost(String postId) {
    if (_likedPostIds.contains(postId)) {
      _likedPostIds.remove(postId);
      _postLikeCounts[postId] = (_postLikeCounts[postId] ?? 0) - 1;
    } else {
      _likedPostIds.add(postId);
      _postLikeCounts[postId] = (_postLikeCounts[postId] ?? 0) + 1;
    }
    notifyListeners();
  }

  void toggleBookmarkPost(String postId) {
    if (_bookmarkedPostIds.contains(postId)) {
      _bookmarkedPostIds.remove(postId);
    } else {
      _bookmarkedPostIds.add(postId);
    }
    notifyListeners();
  }

  // Music filtering
  void filterSongsByMood(String mood) {
    _filteredSongs = MusicData.getSongsByMood(mood);
    notifyListeners();
  }

  void filterSongsByGenre(String genre) {
    _filteredSongs = MusicData.getSongsByGenre(genre);
    notifyListeners();
  }

  void resetMusicFilter() {
    _filteredSongs = List.from(_recommendedSongs);
    notifyListeners();
  }

  // Getters for interaction data
  int getPostLikeCount(String postId) => _postLikeCounts[postId] ?? 0;
  int getPostCommentCount(String postId) => _postCommentCounts[postId] ?? 0;
  int getPostShareCount(String postId) => _postShareCounts[postId] ?? 0;
  bool isPostLiked(String postId) => _likedPostIds.contains(postId);
  bool isPostBookmarked(String postId) => _bookmarkedPostIds.contains(postId);

  // Refresh data
  Future<void> refreshPosts() async {
    await _loadPosts();
  }

  Future<void> refreshMatches() async {
    await _loadMatches();
  }

  Future<void> refreshMusicData() async {
    await _loadMusicData();
  }

  // Clear all data
  void clearAllData() {
    _posts.clear();
    _matches.clear();
    _recommendedSongs.clear();
    _filteredSongs.clear();
    _mbtiStories.clear();
    _likedPostIds.clear();
    _bookmarkedPostIds.clear();
    _postLikeCounts.clear();
    _postCommentCounts.clear();
    _postShareCounts.clear();
    notifyListeners();
  }

  // Load MBTI stories data
  Future<void> _loadStories() async {
    _isLoadingStories = true;
    _storiesError = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 400));

      // Generate dummy MBTI stories using data models
      _mbtiStories = [
        {
          'id': 'story_1',
          'username': 'Alex Chen',
          'mbtiType': 'INTJ',
          'avatar': '👩‍💻',
          'timeAgo': '2h',
          'storyType': 'text',
          'title': 'Cognitive Functions Discovery',
          'content':
              'Just discovered my cognitive functions! Te-Ni-Se-Fi makes so much sense now 🧠✨',
          'backgroundColor': '#9C27B0',
          'textColor': '#FFFFFF',
          'fontSize': 24.0,
          'fontWeight': 'bold',
          'textAlign': 'center',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'likes': 45,
          'views': 123,
        },
        {
          'id': 'story_2',
          'username': 'Sarah Martinez',
          'mbtiType': 'ENFP',
          'avatar': '🎨',
          'timeAgo': '4h',
          'storyType': 'image',
          'title': 'MBTI Color Theory',
          'content':
              'Created this visual representation of how different MBTI types experience colors!',
          'imageThumbnail': '🎨',
          'backgroundColor': '#00BCD4',
          'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
          'likes': 78,
          'views': 256,
        },
        {
          'id': 'story_3',
          'username': 'Marcus Rodriguez',
          'mbtiType': 'ENTP',
          'avatar': '🔬',
          'timeAgo': '6h',
          'storyType': 'poll',
          'title': 'MBTI Debate',
          'content':
              'Which cognitive function do you think is most underrated?',
          'pollOptions': ['Ti', 'Ne', 'Fe', 'Si'],
          'backgroundColor': '#2196F3',
          'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
          'likes': 92,
          'views': 189,
        },
        {
          'id': 'add_story',
          'username': 'Your Story',
          'avatar': '➕',
          'storyType': 'add',
          'timestamp': DateTime.now(),
        },
      ];

      _isLoadingStories = false;
      notifyListeners();
    } catch (e) {
      _storiesError = 'Failed to load stories: $e';
      _isLoadingStories = false;
      notifyListeners();
    }
  }

  // Create MBTI story methods
  Future<bool> createTextStory({
    required String title,
    required String content,
    required String backgroundColor,
    required String textColor,
    required double fontSize,
    required String fontWeight,
    required String textAlign,
  }) async {
    _isCreatingStory = true;
    _createStoryError = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));

      // Create new story using data from models
      final newStory = {
        'id': 'story_${DateTime.now().millisecondsSinceEpoch}',
        'username': 'You',
        'mbtiType': 'INTJ', // Would come from user profile
        'avatar': '👤',
        'timeAgo': 'just now',
        'storyType': 'text',
        'title': title,
        'content': content,
        'backgroundColor': backgroundColor,
        'textColor': textColor,
        'fontSize': fontSize,
        'fontWeight': fontWeight,
        'textAlign': textAlign,
        'timestamp': DateTime.now(),
        'likes': 0,
        'views': 0,
      };

      // Add to stories list (insert at beginning, before "add_story")
      final addStoryIndex = _mbtiStories.indexWhere(
        (story) => story['id'] == 'add_story',
      );
      if (addStoryIndex != -1) {
        _mbtiStories.insert(addStoryIndex, newStory);
      } else {
        _mbtiStories.insert(0, newStory);
      }

      _lastCreatedStory = newStory;
      _isCreatingStory = false;
      notifyListeners();

      return true;
    } catch (e) {
      _createStoryError = 'Failed to create story: $e';
      _isCreatingStory = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createPollStory({
    required String title,
    required String question,
    required List<String> options,
    required int durationHours,
    bool allowMultipleSelection = false,
    bool isAnonymous = false,
  }) async {
    _isCreatingStory = true;
    _createStoryError = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));

      // Create new poll story using poll data model
      final newStory = {
        'id': 'story_${DateTime.now().millisecondsSinceEpoch}',
        'username': 'You',
        'mbtiType': 'INTJ', // Would come from user profile
        'avatar': '👤',
        'timeAgo': 'just now',
        'storyType': 'poll',
        'title': title,
        'content': question,
        'pollOptions': options,
        'duration': durationHours,
        'allowMultipleSelection': allowMultipleSelection,
        'isAnonymous': isAnonymous,
        'backgroundColor': TextStoryData.defaultBackgroundColorHex,
        'timestamp': DateTime.now(),
        'likes': 0,
        'views': 0,
        'totalVotes': 0,
      };

      // Add to stories list
      final addStoryIndex = _mbtiStories.indexWhere(
        (story) => story['id'] == 'add_story',
      );
      if (addStoryIndex != -1) {
        _mbtiStories.insert(addStoryIndex, newStory);
      } else {
        _mbtiStories.insert(0, newStory);
      }

      _lastCreatedStory = newStory;
      _isCreatingStory = false;
      notifyListeners();

      return true;
    } catch (e) {
      _createStoryError = 'Failed to create poll: $e';
      _isCreatingStory = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createMusicStory({
    required String title,
    required MusicSong song,
    String? description,
  }) async {
    _isCreatingStory = true;
    _createStoryError = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));

      // Create new music story
      final newStory = {
        'id': 'story_${DateTime.now().millisecondsSinceEpoch}',
        'username': 'You',
        'mbtiType': 'INTJ', // Would come from user profile
        'avatar': '👤',
        'timeAgo': 'just now',
        'storyType': 'music',
        'title': title,
        'content': description ?? 'Sharing this vibe with you all 🎵',
        'song': song.toJson(),
        'backgroundColor': '#9C27B0',
        'timestamp': DateTime.now(),
        'likes': 0,
        'views': 0,
      };

      // Add to stories list
      final addStoryIndex = _mbtiStories.indexWhere(
        (story) => story['id'] == 'add_story',
      );
      if (addStoryIndex != -1) {
        _mbtiStories.insert(addStoryIndex, newStory);
      } else {
        _mbtiStories.insert(0, newStory);
      }

      _lastCreatedStory = newStory;
      _isCreatingStory = false;
      notifyListeners();

      return true;
    } catch (e) {
      _createStoryError = 'Failed to create music story: $e';
      _isCreatingStory = false;
      notifyListeners();
      return false;
    }
  }

  // Story interactions
  void likeStory(String storyId) {
    final storyIndex = _mbtiStories.indexWhere(
      (story) => story['id'] == storyId,
    );
    if (storyIndex != -1) {
      final story = _mbtiStories[storyIndex];
      final currentLikes = story['likes'] as int;
      _mbtiStories[storyIndex]['likes'] = currentLikes + 1;
      notifyListeners();
    }
  }

  // Refresh stories
  Future<void> refreshStories() async {
    await _loadStories();
  }

  // Get stories by MBTI type
  List<Map<String, dynamic>> getStoriesByMBTIType(String mbtiType) {
    return _mbtiStories
        .where(
          (story) =>
              story['mbtiType'] == mbtiType && story['id'] != 'add_story',
        )
        .toList();
  }

  // Get stories by type
  List<Map<String, dynamic>> getStoriesByType(String storyType) {
    return _mbtiStories
        .where(
          (story) =>
              story['storyType'] == storyType && story['id'] != 'add_story',
        )
        .toList();
  }
}
