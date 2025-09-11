import 'package:opop/features/profile/data/models/friend_profile.dart';

class ChatFriendClass {
  static List<FriendProfile> _getDummyFriends() {
    return [
      FriendProfile(
        id: '1',
        name: 'Sarah Chen',
        avatar: '👩‍🦰',
        mbtiType: 'ENFP',
        status: 'Active',
        lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
        conversationCount: 12,
      ),
      FriendProfile(
        id: '2',
        name: 'Alex Rodriguez',
        avatar: '👨‍💼',
        mbtiType: 'INFJ',
        status: 'Active',
        lastSeen: DateTime.now().subtract(const Duration(minutes: 15)),
        conversationCount: 8,
      ),
      FriendProfile(
        id: '3',
        name: 'Jordan Kim',
        avatar: '👨‍🎓',
        mbtiType: 'ENTP',
        status: 'Away',
        lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
        conversationCount: 5,
      ),
      FriendProfile(
        id: '4',
        name: 'Maya Patel',
        avatar: '👩‍🔬',
        mbtiType: 'INTJ',
        status: 'Active',
        lastSeen: DateTime.now().subtract(const Duration(minutes: 45)),
        conversationCount: 15,
      ),
      FriendProfile(
        id: '5',
        name: 'Chris Thompson',
        avatar: '👨‍🎨',
        mbtiType: 'ISFP',
        status: 'Offline',
        lastSeen: DateTime.now().subtract(const Duration(hours: 3)),
        conversationCount: 3,
      ),
      FriendProfile(
        id: '6',
        name: 'Emma Wilson',
        avatar: '👩‍💻',
        mbtiType: 'ENTJ',
        status: 'Active',
        lastSeen: DateTime.now().subtract(const Duration(minutes: 20)),
        conversationCount: 7,
      ),
      FriendProfile(
        id: '7',
        name: 'David Park',
        avatar: '👨‍⚕️',
        mbtiType: 'ESFJ',
        status: 'Active',
        lastSeen: DateTime.now().subtract(const Duration(minutes: 10)),
        conversationCount: 9,
      ),
      FriendProfile(
        id: '8',
        name: 'Lisa Chang',
        avatar: '👩‍🏫',
        mbtiType: 'INFP',
        status: 'Away',
        lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
        conversationCount: 11,
      ),
    ];
  }

  static List<FriendProfile> get friends => _getDummyFriends();
}
