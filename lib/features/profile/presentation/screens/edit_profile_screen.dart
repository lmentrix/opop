import 'package:flutter/material.dart';
import 'package:opop/features/profile/presentation/screens/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/models/user_profile.dart';

/// Edit profile screen for updating user information
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;

  String _selectedMBTI = 'INTJ';
  String _selectedAvatar = '👩‍💻';
  bool _isLoading = false;
  bool _hasChanges = false;

  final List<String> _mbtiTypes = [
    'INTJ', 'INTP', 'ENTJ', 'ENTP', // Analysts
    'INFJ', 'INFP', 'ENFJ', 'ENFP', // Diplomats
    'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ', // Sentinels
    'ISTP', 'ISFP', 'ESTP', 'ESFP', // Explorers
  ];

  final List<String> _avatarOptions = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    _avatarOptions.addAll(profileProvider.avatarOptions);
    _loadUserData();
  }

  void _initializeControllers() {
    _displayNameController = TextEditingController();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _locationController = TextEditingController();
    _bioController = TextEditingController();

    // Add listeners to detect changes
    _displayNameController.addListener(_onFieldChanged);
    _fullNameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _locationController.addListener(_onFieldChanged);
    _bioController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  void _loadUserData() {
    // Load dummy user data
    final userData = UserProfile.dummyData();
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    _displayNameController.text = userData.displayName;
    _fullNameController.text = userData.fullName;
    _emailController.text = userData.email;
    _locationController.text = userData.location;
    _bioController.text = userData.bio;
    _selectedMBTI = userData.mbtiType;
    _selectedAvatar = profileProvider.selectedAvatar; // Get from provider
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        if (_selectedAvatar != profileProvider.selectedAvatar) {
          _selectedAvatar = profileProvider.selectedAvatar;
          _hasChanges = true;
        }
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfilePictureSection(),
                          const SizedBox(height: AppSpacing.xl),
                          _buildPersonalInfoSection(),
                          const SizedBox(height: AppSpacing.xl),
                          _buildMBTISection(),
                          const SizedBox(height: AppSpacing.xl),
                          _buildLocationSection(),
                          const SizedBox(height: AppSpacing.xl),
                          _buildBioSection(),
                          const SizedBox(height: AppSpacing.xxxl),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildSaveButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _onBackPressed,
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: AppSpacing.iconSize,
            ),
          ),
          Expanded(
            child: Text(
              'Edit Profile',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (_hasChanges)
            TextButton(
              onPressed: _resetChanges,
              child: Text(
                'Reset',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            )
          else
            const SizedBox(width: 60),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Picture',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: _showAvatarPicker,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _getMBTIGradient(_selectedMBTI),
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.full),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _selectedAvatar,
                      style: AppTypography.displaySmall.copyWith(fontSize: 50),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Tap to change avatar',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTextField(
          controller: _displayNameController,
          label: 'Display Name',
          hint: 'How others see you',
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Display name is required';
            }
            if (value.trim().length < 2) {
              return 'Display name must be at least 2 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTextField(
          controller: _fullNameController,
          label: 'Full Name',
          hint: 'Your complete name',
          icon: Icons.badge,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Full name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'your.email@example.com',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email is required';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMBTISection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MBTI Personality Type',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSpacing.md),
            border: Border.all(
              color: _getMBTIColor(_selectedMBTI).withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: _getMBTIColor(_selectedMBTI).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                    child: Icon(
                      Icons.psychology,
                      color: _getMBTIColor(_selectedMBTI),
                      size: AppSpacing.iconSize,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMBTI,
                      decoration: const InputDecoration(
                        labelText: 'Select your MBTI type',
                        border: InputBorder.none,
                      ),
                      items: _mbtiTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _getMBTIColor(type),
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.full,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                type,
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                _getMBTIDescription(type),
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedMBTI = value;
                            _hasChanges = true;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _getMBTILongDescription(_selectedMBTI),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.3,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTextField(
          controller: _locationController,
          label: 'Location',
          hint: 'City, State/Country',
          icon: Icons.location_on,
          validator: (value) {
            if (value != null && value.isNotEmpty && value.length < 2) {
              return 'Location must be at least 2 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bio',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          controller: _bioController,
          maxLines: 4,
          maxLength: 200,
          decoration: InputDecoration(
            labelText: 'Tell others about yourself',
            hintText:
                'Share your interests, passions, or what makes you unique...',
            prefixIcon: Icon(Icons.edit_note, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.md),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          style: AppTypography.bodyMedium.copyWith(letterSpacing: 0.3),
          validator: (value) {
            if (value != null && value.length > 200) {
              return 'Bio must be 200 characters or less';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      style: AppTypography.bodyMedium.copyWith(letterSpacing: 0.3),
      validator: validator,
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _hasChanges ? _saveProfile : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _hasChanges
                ? AppColors.primary
                : AppColors.textDisabled,
            foregroundColor: AppColors.textInverse,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.textInverse,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Save Changes',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }

  void _showAvatarPicker() {
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
                'Choose Avatar',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: _avatarOptions.length,
                  itemBuilder: (context, index) {
                    final avatar = _avatarOptions[index];
                    final isSelected = avatar == _selectedAvatar;

                    return GestureDetector(
                      onTap: () {
                        final profileProvider = Provider.of<ProfileProvider>(
                          context,
                          listen: false,
                        );
                        profileProvider.updateAvatar(
                          avatar,
                        ); // Update provider state
                        setState(() {
                          _selectedAvatar = avatar;
                          _hasChanges = true;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: _getMBTIGradient(_selectedMBTI),
                                )
                              : null,
                          color: isSelected
                              ? null
                              : AppColors.surfaceVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(AppSpacing.md),
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            avatar,
                            style: AppTypography.titleLarge.copyWith(
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  void _onBackPressed() {
    if (_hasChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Unsaved Changes',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          content: Text(
            'You have unsaved changes. Are you sure you want to leave?',
            style: AppTypography.bodyMedium.copyWith(letterSpacing: 0.3),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'Leave',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _resetChanges() {
    setState(() {
      _hasChanges = false;
    });

    // Reset avatar from provider
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    setState(() {
      _selectedAvatar = profileProvider.selectedAvatar;
    });

    _loadUserData();
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Get provider instance
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    // Update provider with the selected avatar
    profileProvider.updateAvatar(_selectedAvatar);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _hasChanges = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated successfully!',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textInverse,
              letterSpacing: 0.3,
            ),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  List<Color> _getMBTIGradient(String mbtiType) {
    final color = _getMBTIColor(mbtiType);
    return [color, color.withOpacity(0.7)];
  }

  Color _getMBTIColor(String mbtiType) {
    switch (mbtiType.substring(0, 2)) {
      case 'IN':
      case 'EN':
        if (mbtiType.endsWith('TJ') || mbtiType.endsWith('TP')) {
          return AppColors.analyst; // NT types
        } else {
          return AppColors.diplomat; // NF types
        }
      case 'IS':
      case 'ES':
        if (mbtiType.endsWith('TJ') || mbtiType.endsWith('FJ')) {
          return AppColors.sentinel; // SJ types
        } else {
          return AppColors.explorer; // SP types
        }
      default:
        return AppColors.primary;
    }
  }

  String _getMBTIDescription(String mbtiType) {
    switch (mbtiType) {
      case 'INTJ':
        return 'Architect';
      case 'INTP':
        return 'Logician';
      case 'ENTJ':
        return 'Commander';
      case 'ENTP':
        return 'Debater';
      case 'INFJ':
        return 'Advocate';
      case 'INFP':
        return 'Mediator';
      case 'ENFJ':
        return 'Protagonist';
      case 'ENFP':
        return 'Campaigner';
      case 'ISTJ':
        return 'Logistician';
      case 'ISFJ':
        return 'Defender';
      case 'ESTJ':
        return 'Executive';
      case 'ESFJ':
        return 'Consul';
      case 'ISTP':
        return 'Virtuoso';
      case 'ISFP':
        return 'Adventurer';
      case 'ESTP':
        return 'Entrepreneur';
      case 'ESFP':
        return 'Entertainer';
      default:
        return 'Explorer';
    }
  }

  String _getMBTILongDescription(String mbtiType) {
    switch (mbtiType) {
      case 'INTJ':
        return 'Imaginative and strategic thinkers, with a plan for everything.';
      case 'INTP':
        return 'Innovative inventors with an unquenchable thirst for knowledge.';
      case 'ENTJ':
        return 'Bold, imaginative and strong-willed leaders.';
      case 'ENTP':
        return 'Smart and curious thinkers who cannot resist an intellectual challenge.';
      case 'INFJ':
        return 'Quiet and mystical, yet very inspiring and tireless idealists.';
      case 'INFP':
        return 'Poetic, kind and altruistic people, always eager to help a good cause.';
      case 'ENFJ':
        return 'Charismatic and inspiring leaders, able to mesmerize their listeners.';
      case 'ENFP':
        return 'Enthusiastic, creative and sociable free spirits.';
      case 'ISTJ':
        return 'Practical and fact-minded, whose reliability cannot be doubted.';
      case 'ISFJ':
        return 'Very dedicated and warm protectors, always ready to defend their loved ones.';
      case 'ESTJ':
        return 'Excellent administrators, unsurpassed at managing things or people.';
      case 'ESFJ':
        return 'Extraordinarily caring, social and popular people, always eager to help.';
      case 'ISTP':
        return 'Bold and practical experimenters, masters of all kinds of tools.';
      case 'ISFP':
        return 'Flexible and charming artists, always ready to explore new possibilities.';
      case 'ESTP':
        return 'Smart, energetic and very perceptive people, truly enjoy living on the edge.';
      case 'ESFP':
        return 'Spontaneous, energetic and enthusiastic people - life is never boring.';
      default:
        return 'Unique personality with their own strengths and characteristics.';
    }
  }
}
