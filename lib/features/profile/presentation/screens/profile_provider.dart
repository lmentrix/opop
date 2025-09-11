// lib/features/profile/presentation/providers/profile_provider.dart

import 'package:flutter/foundation.dart';

import '../../data/models/friend_profile.dart';

class ProfileProvider extends ChangeNotifier {
  final List<String> _avatarOptions = [
    '👩‍💻',
    '👨‍💻',
    '🎨',
    '📚',
    '💡',
    '🎭',
    '📊',
    '🎵',
    '🌟',
    '🔬',
    '✍️',
    '🎯',
    '🧠',
    '💼',
    '🎪',
    '🌱',
  ];

  List<String> get avatarOptions => _avatarOptions;

  String _selectedAvatar = '👩‍💻';
  String get selectedAvatar => _selectedAvatar;

  void updateAvatar(String avatar) {
    _selectedAvatar = avatar;
    notifyListeners();
  }

  // Friend Profiles Management
  final List<FriendProfile> _friendProfiles = [
    FriendProfile(
      id: 'friend_1',
      name: 'Sarah Chen',
      avatar: '👩‍💻',
      mbtiType: 'ENFP',
      status: 'online',
      lastSeen: DateTime.now(),
      conversationCount: 12,
    ),
    FriendProfile(
      id: 'friend_2',
      name: 'Alex Rivera',
      avatar: '👨‍💻',
      mbtiType: 'INTJ',
      status: 'offline',
      lastSeen: DateTime.now().subtract(Duration(hours: 2)),
      conversationCount: 8,
    ),
    FriendProfile(
      id: 'friend_3',
      name: 'Maya Patel',
      avatar: '🎨',
      mbtiType: 'INFP',
      status: 'online',
      lastSeen: DateTime.now(),
      conversationCount: 15,
    ),
    FriendProfile(
      id: 'friend_4',
      name: 'Jordan Kim',
      avatar: '📚',
      mbtiType: 'ENTJ',
      status: 'away',
      lastSeen: DateTime.now().subtract(Duration(minutes: 30)),
      conversationCount: 6,
    ),
  ];

  List<FriendProfile> get friendProfiles => _friendProfiles;

  FriendProfile? getFriendProfile(String id) {
    try {
      return _friendProfiles.firstWhere((profile) => profile.id == id);
    } catch (e) {
      return null;
    }
  }

  void addFriendProfile(FriendProfile profile) {
    _friendProfiles.add(profile);
    notifyListeners();
  }

  void updateFriendProfile(FriendProfile updatedProfile) {
    final index = _friendProfiles.indexWhere(
      (profile) => profile.id == updatedProfile.id,
    );
    if (index != -1) {
      _friendProfiles[index] = updatedProfile;
      notifyListeners();
    }
  }

  void removeFriendProfile(String id) {
    _friendProfiles.removeWhere((profile) => profile.id == id);
    notifyListeners();
  }

  void updateFriendStatus(String id, String status) {
    final index = _friendProfiles.indexWhere((profile) => profile.id == id);
    if (index != -1) {
      _friendProfiles[index] = FriendProfile(
        id: _friendProfiles[index].id,
        name: _friendProfiles[index].name,
        avatar: _friendProfiles[index].avatar,
        mbtiType: _friendProfiles[index].mbtiType,
        status: status,
        lastSeen: DateTime.now(),
        conversationCount: _friendProfiles[index].conversationCount,
      );
      notifyListeners();
    }
  }

  List<FriendProfile> getOnlineFriends() {
    return _friendProfiles
        .where((profile) => profile.status == 'online')
        .toList();
  }

  List<FriendProfile> getRecentFriends() {
    return _friendProfiles
        .where(
          (profile) =>
              profile.lastSeen != null &&
              profile.lastSeen!.isAfter(
                DateTime.now().subtract(Duration(days: 7)),
              ),
        )
        .toList();
  }
}
