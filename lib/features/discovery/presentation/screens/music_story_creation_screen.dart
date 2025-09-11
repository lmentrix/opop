import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/core/constants/app_spacing.dart';
import 'package:opop/core/constants/app_typography.dart';

class MusicStoryCreationScreen extends StatefulWidget {
  const MusicStoryCreationScreen({super.key});

  @override
  State<MusicStoryCreationScreen> createState() =>
      _MusicStoryCreationScreenState();
}

class _MusicStoryCreationScreenState extends State<MusicStoryCreationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedMood = 'Energetic';
  String _selectedGenre = 'Pop';
  double _energyLevel = 0.7;
  bool _isPlaying = false;

  final List<String> _moods = [
    'Energetic',
    'Calm',
    'Happy',
    'Sad',
    'Romantic',
    'Mysterious',
    'Inspiring',
  ];

  final List<String> _genres = [
    'Pop',
    'Rock',
    'Hip Hop',
    'Electronic',
    'Classical',
    'Jazz',
    'R&B',
    'Country',
  ];

  final List<Map<String, dynamic>> _recommendedSongs = [
    {
      'title': 'Blinding Lights',
      'artist': 'The Weeknd',
      'mood': 'Energetic',
      'genre': 'Pop',
      'duration': '3:20',
      'energy': 0.8,
    },
    {
      'title': 'Bohemian Rhapsody',
      'artist': 'Queen',
      'mood': 'Energetic',
      'genre': 'Rock',
      'duration': '5:55',
      'energy': 0.9,
    },
    {
      'title': 'Shape of You',
      'artist': 'Ed Sheeran',
      'mood': 'Happy',
      'genre': 'Pop',
      'duration': '3:53',
      'energy': 0.6,
    },
    {
      'title': 'Someone Like You',
      'artist': 'Adele',
      'mood': 'Sad',
      'genre': 'Pop',
      'duration': '4:45',
      'energy': 0.3,
    },
    {
      'title': 'Clair de Lune',
      'artist': 'Debussy',
      'mood': 'Calm',
      'genre': 'Classical',
      'duration': '5:04',
      'energy': 0.2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _pulseController.repeat(reverse: true);
    _slideController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _captionController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
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
          'Create Music Story',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isFormValid ? _createMusicStory : null,
            child: Text(
              'Create',
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
            // Music Visualizer
            _buildMusicVisualizer(),

            // Song Details
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Song Details',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Title Input
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Song Title',
                      hintText: 'Enter song title...',
                      prefixIcon: const Icon(Icons.music_note),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    style: AppTypography.bodyMedium,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Artist Input
                  TextField(
                    controller: _artistController,
                    decoration: InputDecoration(
                      labelText: 'Artist',
                      hintText: 'Enter artist name...',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    style: AppTypography.bodyMedium,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Caption Input
                  TextField(
                    controller: _captionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Caption (Optional)',
                      hintText: 'What does this song mean to you?',
                      prefixIcon: const Icon(Icons.chat),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Music Settings
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Music Settings',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Mood Selector
                  _buildMoodSelector(),
                  const SizedBox(height: AppSpacing.md),

                  // Genre Selector
                  _buildGenreSelector(),
                  const SizedBox(height: AppSpacing.md),

                  // Energy Level
                  _buildEnergySelector(),
                ],
              ),
            ),

            const Divider(height: 1),

            // Recommended Songs
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended Songs',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _recommendedSongs.length,
                      itemBuilder: (context, index) {
                        final song = _recommendedSongs[index];
                        return _buildRecommendedSongCard(song);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicVisualizer() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        child: Stack(
          children: [
            // Animated Background
            Positioned.fill(
              child: CustomPaint(
                painter: MusicVisualizerPainter(_isPlaying, _energyLevel),
              ),
            ),

            // Music Info
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isPlaying ? _pulseAnimation.value : 1.0,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.textInverse.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.full,
                            ),
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppColors.primary,
                            size: AppSpacing.iconSize * 2,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _titleController.text.isNotEmpty
                        ? _titleController.text
                        : 'Select a Song',
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.textInverse,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_artistController.text.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _artistController.text,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textInverse.withOpacity(0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Play Button Overlay
            Positioned.fill(
              child: GestureDetector(
                onTap: _togglePlay,
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
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
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSpacing.full),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.outline,
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
    );
  }

  Widget _buildGenreSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Genre',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          value: _selectedGenre,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.md),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          items: _genres.map((genre) {
            return DropdownMenuItem(value: genre, child: Text(genre));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedGenre = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildEnergySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Energy Level',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(_energyLevel * 100).round()}%',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Slider(
          value: _energyLevel,
          min: 0.0,
          max: 1.0,
          divisions: 10,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.textDisabled,
          onChanged: (value) {
            setState(() {
              _energyLevel = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRecommendedSongCard(Map<String, dynamic> song) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.outline.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () => _selectRecommendedSong(song),
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: const Icon(
                  Icons.music_note,
                  color: AppColors.textInverse,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                song['title'] as String,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                song['artist'] as String,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Text(
                    song['duration'] as String,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textDisabled,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textDisabled,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    song['mood'] as String,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _selectRecommendedSong(Map<String, dynamic> song) {
    setState(() {
      _titleController.text = song['title'] as String;
      _artistController.text = song['artist'] as String;
      _selectedMood = song['mood'] as String;
      _selectedGenre = song['genre'] as String;
      _energyLevel = song['energy'] as double;
    });
  }

  bool get _isFormValid =>
      _titleController.text.trim().isNotEmpty &&
      _artistController.text.trim().isNotEmpty;

  void _createMusicStory() {
    if (!_isFormValid) return;

    // Create music story data
    final musicStoryData = {
      'type': 'music',
      'title': _titleController.text,
      'artist': _artistController.text,
      'caption': _captionController.text,
      'mood': _selectedMood,
      'genre': _selectedGenre,
      'energyLevel': _energyLevel,
      'timestamp': DateTime.now(),
    };

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Music story created successfully! 🎵'),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.success,
      ),
    );

    // Navigate back
    Navigator.pop(context, musicStoryData);
  }
}

class MusicVisualizerPainter extends CustomPainter {
  final bool isPlaying;
  final double energyLevel;

  MusicVisualizerPainter(this.isPlaying, this.energyLevel);

  @override
  void paint(Canvas canvas, Size size) {
    if (!isPlaying) return;

    final paint = Paint()
      ..color = AppColors.textInverse.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final barCount = 20;
    final barWidth = size.width / barCount;

    for (int i = 0; i < barCount; i++) {
      final barHeight =
          (size.height * 0.3 * energyLevel) *
          (0.5 + 0.5 * (i % 3 == 0 ? 1.0 : 0.5));

      final x = i * barWidth + barWidth * 0.2;
      final y = size.height - barHeight;

      canvas.drawRect(Rect.fromLTWH(x, y, barWidth * 0.6, barHeight), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
