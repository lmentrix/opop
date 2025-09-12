import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/core/constants/app_spacing.dart';
import 'package:opop/core/constants/app_typography.dart';
import 'package:opop/features/discovery/data/models/text_story_data.dart';
import 'package:opop/features/discovery/provider/discovery_provider.dart';
import 'package:provider/provider.dart';

class TextStoryCreationScreen extends StatefulWidget {
  const TextStoryCreationScreen({super.key});

  @override
  State<TextStoryCreationScreen> createState() => _TextStoryCreationScreenState();
}

class _TextStoryCreationScreenState extends State<TextStoryCreationScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  
  Color _selectedBackgroundColor = AppColors.diplomat;
  Color _selectedTextColor = AppColors.textInverse;
  double _fontSize = TextStoryData.defaultFontSize;
  FontWeight _fontWeight = TextStoryData.getFontWeight(TextStoryData.defaultFontWeight);
  TextAlign _textAlign = TextStoryData.getTextAlign(TextStoryData.defaultTextAlignment);
  
  final List<Color> _backgroundColors = [
    AppColors.diplomat,
    AppColors.analyst,
    AppColors.sentinel,
    AppColors.explorer,
    AppColors.primary,
    AppColors.error,
    AppColors.warning,
    AppColors.success,
  ];
  
  final List<double> _fontSizes = TextStoryData.fontSizes;
  final List<FontWeight> _fontWeights = TextStoryData.fontWeightNames
      .map((name) => TextStoryData.getFontWeight(name))
      .toList();
  final List<TextAlign> _textAligns = TextStoryData.textAlignments
      .map((name) => TextStoryData.getTextAlign(name))
      .toList();

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
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
          'Create Text Story',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isFormValid ? _createStory : null,
            child: Text(
              'Post',
              style: AppTypography.titleMedium.copyWith(
                color: _isFormValid ? AppColors.primary : AppColors.textDisabled,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Story Preview
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: _selectedBackgroundColor,
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                child: Stack(
                  children: [
                    // Background Pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: StoryBackgroundPainter(_selectedBackgroundColor),
                      ),
                    ),
                    
                    // Story Content
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          if (_titleController.text.isNotEmpty) ...[
                            Text(
                              _titleController.text,
                              style: TextStyle(
                                color: _selectedTextColor,
                                fontSize: _fontSize + 8,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                              textAlign: _textAlign,
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                child: Text(
                                  _textController.text.isNotEmpty
                                      ? _textController.text
                                      : 'Start typing your MBTI story...',
                                  style: TextStyle(
                                    color: _textController.text.isEmpty
                                        ? _selectedTextColor.withOpacity(0.5)
                                        : _selectedTextColor,
                                    fontSize: _fontSize,
                                    fontWeight: _fontWeight,
                                    height: 1.4,
                                  ),
                                  textAlign: _textAlign,
                                ),
                              ),
                            ),
                          ),
                          
                          // MBTI Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.textInverse.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppSpacing.full),
                            ),
                            child: Text(
                              'MBTI Story',
                              style: AppTypography.bodySmall.copyWith(
                                color: _selectedTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Editing Controls
          Container(
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
                // Title Input
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Story Title (Optional)',
                      hintText: 'Enter a catchy title...',
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
                ),
                
                // Text Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: TextField(
                    controller: _textController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Your Story',
                      hintText: 'Share your MBTI thoughts and insights...',
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
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Customization Options
                _buildCustomizationOptions(),
                
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizationOptions() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(text: 'Background'),
              Tab(text: 'Text'),
              Tab(text: 'Size'),
              Tab(text: 'Align'),
            ],
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
          ),
          
          SizedBox(
            height: 120,
            child: TabBarView(
              children: [
                // Background Colors
                _buildColorSelector(),
                
                // Text Options
                _buildTextOptions(),
                
                // Font Size
                _buildFontSizeSelector(),
                
                // Text Alignment
                _buildAlignmentSelector(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: _backgroundColors.length,
      itemBuilder: (context, index) {
        final color = _backgroundColors[index];
        final isSelected = color == _selectedBackgroundColor;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedBackgroundColor = color;
              _selectedTextColor = _getTextColorForBackground(color);
            });
          },
          child: Container(
            width: 60,
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSpacing.md),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildTextOptions() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: _fontWeights.length,
      itemBuilder: (context, index) {
        final weight = _fontWeights[index];
        final isSelected = weight == _fontWeight;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _fontWeight = weight;
            });
          },
          child: Container(
            width: 80,
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.md),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.outline,
              ),
            ),
            child: Center(
              child: Text(
                'Aa',
                style: TextStyle(
                  fontWeight: weight,
                  color: isSelected ? AppColors.textInverse : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFontSizeSelector() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: _fontSizes.length,
      itemBuilder: (context, index) {
        final size = _fontSizes[index];
        final isSelected = size == _fontSize;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _fontSize = size;
            });
          },
          child: Container(
            width: 60,
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.md),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.outline,
              ),
            ),
            child: Center(
              child: Text(
                '${size.toInt()}',
                style: TextStyle(
                  fontSize: size * 0.7,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.textInverse : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlignmentSelector() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: _textAligns.length,
      itemBuilder: (context, index) {
        final align = _textAligns[index];
        final isSelected = align == _textAlign;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _textAlign = align;
            });
          },
          child: Container(
            width: 80,
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.md),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.outline,
              ),
            ),
            child: Center(
              child: Icon(
                _getAlignmentIcon(align),
                color: isSelected ? AppColors.textInverse : AppColors.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getAlignmentIcon(TextAlign align) {
    final alignmentName = TextStoryData.textAlignments.firstWhere(
      (name) => TextStoryData.getTextAlign(name) == align,
      orElse: () => TextStoryData.defaultTextAlignment,
    );
    final iconName = TextStoryData.getAlignmentIcon(alignmentName);
    
    switch (iconName) {
      case 'format_align_left':
        return Icons.format_align_left;
      case 'format_align_center':
        return Icons.format_align_center;
      case 'format_align_right':
        return Icons.format_align_right;
      default:
        return Icons.format_align_center;
    }
  }

  Color _getTextColorForBackground(Color backgroundColor) {
    // Calculate luminance to determine if we should use light or dark text
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? AppColors.textPrimary : AppColors.textInverse;
  }

  bool get _isFormValid => _textController.text.trim().isNotEmpty;

  void _createStory() async {
    if (!_isFormValid) return;
    
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Creating your MBTI story...'),
        duration: Duration(seconds: 1),
      ),
    );
    
    // Use discovery provider to create story
    final provider = Provider.of<DiscoveryProvider>(context, listen: false);
    final success = await provider.createTextStory(
      title: _titleController.text.isNotEmpty ? _titleController.text : 'MBTI Story',
      content: _textController.text,
      backgroundColor: '#${_selectedBackgroundColor.value.toRadixString(16).substring(2)}',
      textColor: '#${_selectedTextColor.value.toRadixString(16).substring(2)}',
      fontSize: _fontSize,
      fontWeight: _fontWeight == FontWeight.normal 
          ? 'normal' 
          : _fontWeight == FontWeight.w500
              ? 'medium'
              : _fontWeight == FontWeight.bold
                  ? 'bold'
                  : 'extra bold',
      textAlign: _textAlign == TextAlign.left 
          ? 'left' 
          : _textAlign == TextAlign.center
              ? 'center'
              : 'right',
    );
    
    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text story created successfully! 📝'),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.success,
        ),
      );
      
      // Navigate back
      Navigator.pop(context, provider.lastCreatedStory);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create story: ${provider.createStoryError}'),
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

class StoryBackgroundPainter extends CustomPainter {
  final Color color;
  
  StoryBackgroundPainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    // Draw subtle pattern
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 20; j++) {
        if ((i + j) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(i * size.width / 20, j * size.height / 20, 
                          size.width / 20, size.height / 20),
            paint,
          );
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}