import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_shadows.dart';
import 'package:opop/features/chat/presentation/data/chat_friend_data.dart';
import 'package:opop/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../profile/data/models/friend_profile.dart';

/// Create group chat screen for MBTI Explorer app
/// Allows users to create group conversations with multiple participants
class CreateGroupChatScreen extends StatefulWidget {
  const CreateGroupChatScreen({super.key});

  @override
  State<CreateGroupChatScreen> createState() => _CreateGroupChatScreenState();
}

class _CreateGroupChatScreenState extends State<CreateGroupChatScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<FriendProfile> _allFriends = [];
  List<FriendProfile> _filteredFriends = [];
  List<String> _selectedParticipantIds = [];
  List<FriendProfile> _selectedParticipants = [];
  bool _isLoading = true;
  bool _isPrivate = false;

  @override
  void initState() {
    super.initState();
    _loadFriends();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _descriptionController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _loadFriends() {
    // Simulate loading friends data
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _allFriends = ChatFriendClass.friends;
          _filteredFriends = _allFriends;
          _isLoading = false;
        });
      }
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFriends = _allFriends.where((friend) {
        return friend.name.toLowerCase().contains(query) ||
            friend.mbtiType.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _toggleParticipant(FriendProfile friend) {
    setState(() {
      if (_selectedParticipantIds.contains(friend.id)) {
        _selectedParticipantIds.remove(friend.id);
        _selectedParticipants.removeWhere((p) => p.id == friend.id);
      } else {
        _selectedParticipantIds.add(friend.id);
        _selectedParticipants.add(friend);
      }
    });
  }

  bool _isParticipantSelected(FriendProfile friend) {
    return _selectedParticipantIds.contains(friend.id);
  }

  Future<void> _createGroup() async {
    if (_groupNameController.text.trim().isEmpty) {
      _showError('Please enter a group name');
      return;
    }

    if (_selectedParticipantIds.isEmpty) {
      _showError('Please select at least one participant');
      return;
    }

    final provider = Provider.of<ChatListProvider>(context, listen: false);

    final success = await provider.createGroupChat(
      title: _groupNameController.text.trim(),
      participantIds: _selectedParticipantIds,
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      isPrivate: _isPrivate,
    );

    if (success && mounted) {
      Navigator.of(context).pop(); // Close create group screen
      _showSuccess('Group created successfully!');
    } else if (mounted) {
      _showError(provider.createChatError ?? 'Failed to create group');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
      ),
    );
  }

  void _removeParticipant(FriendProfile participant) {
    setState(() {
      _selectedParticipantIds.remove(participant.id);
      _selectedParticipants.removeWhere((p) => p.id == participant.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatListProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Create Group Chat',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              TextButton(
                onPressed: provider.isCreatingGroupChat ? null : _createGroup,
                child: provider.isCreatingGroupChat
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : Text(
                        'Create',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildGroupInfoSection(),
              _buildSelectedParticipantsSection(),
              const SizedBox(height: AppSpacing.md),
              _buildSearchBar(),
              const SizedBox(height: AppSpacing.md),
              _buildFriendsList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGroupInfoSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _groupNameController,
            decoration: InputDecoration(
              labelText: 'Group Name',
              hintText: 'Enter group name...',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
                borderSide: BorderSide(color: AppColors.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
                borderSide: BorderSide(
                  color: AppColors.outline.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Enter group description...',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
                borderSide: BorderSide(color: AppColors.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
                borderSide: BorderSide(
                  color: AppColors.outline.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.lock,
                color: _isPrivate ? AppColors.primary : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Private Group',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Switch(
                value: _isPrivate,
                onChanged: (value) {
                  setState(() {
                    _isPrivate = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedParticipantsSection() {
    if (_selectedParticipants.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Participants (${_selectedParticipants.length})',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedParticipants.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final participant = _selectedParticipants[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.full),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(participant.avatar, style: AppTypography.bodySmall),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        participant.name,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      GestureDetector(
                        onTap: () => _removeParticipant(participant),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search friends...',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surfaceVariant.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
        style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildFriendsList() {
    if (_isLoading) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Loading friends...',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredFriends.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_search,
                size: 64,
                color: AppColors.textDisabled,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No friends found',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Try adjusting your search',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textDisabled,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: _filteredFriends.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final friend = _filteredFriends[index];
          return _buildFriendTile(friend);
        },
      ),
    );
  }

  Widget _buildFriendTile(FriendProfile friend) {
    final isSelected = _isParticipantSelected(friend);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getMBTIGradient(friend.mbtiType),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Text(
              friend.avatar,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textInverse,
              ),
            ),
          ),
        ),
        title: Text(
          friend.name,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              friend.mbtiType,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getStatusColor(friend.status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  friend.status ?? 'Offline',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: isSelected
            ? Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.textInverse,
                  size: 20,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.outline),
                ),
                child: Icon(
                  Icons.add,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
        onTap: () => _toggleParticipant(friend),
      ),
    );
  }

  List<Color> _getMBTIGradient(String mbtiType) {
    switch (mbtiType.substring(0, 2)) {
      case 'EN':
        return [AppColors.diplomat, AppColors.diplomat.withOpacity(0.7)];
      case 'ES':
        return [AppColors.explorer, AppColors.explorer.withOpacity(0.7)];
      case 'IN':
        return [AppColors.analyst, AppColors.analyst.withOpacity(0.7)];
      case 'IS':
        return [AppColors.sentinel, AppColors.sentinel.withOpacity(0.7)];
      default:
        return [AppColors.primary, AppColors.primary.withOpacity(0.7)];
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'away':
        return AppColors.warning;
      case 'offline':
        return AppColors.textDisabled;
      default:
        return AppColors.textDisabled;
    }
  }
}
