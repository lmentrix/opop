import 'package:flutter/material.dart';
import '../../../data_passing_sample/data/models/friend_model.dart';
import 'chat_detail_screen.dart';

/// Source screen demonstrating data passing to another screen
/// This screen shows a list of friends and passes data when chat icon is clicked
class FriendsListScreen extends StatelessWidget {
  const FriendsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Passing Demo - Friends'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Click the chat icon to pass friend data to chat screen',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FriendsList(),
          ),
        ],
      ),
    );
  }
}

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  // Sample data - in real app this would come from API or database
  List<FriendModel> get friends => [
    FriendModel(
      id: '1',
      name: 'Emma Davis',
      mbtiType: 'INFJ',
      avatar: '👩‍🎨',
      status: 'Art gallery visit',
      personalityDescription: 'Artistic soul with a passion for creativity',
    ),
    FriendModel(
      id: '2',
      name: 'Sarah Chen',
      mbtiType: 'ENFP',
      avatar: '👩‍💻',
      status: 'Exploring downtown',
      personalityDescription: 'Creative thinker who loves deep conversations',
    ),
    FriendModel(
      id: '3',
      name: 'Mike Johnson',
      mbtiType: 'ISTJ',
      avatar: '👨‍💼',
      status: 'At coffee shop',
      personalityDescription: 'Innovative debater with entrepreneurial spirit',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return FriendCard(
          friend: friend,
          onChatTap: () => _onChatTap(context, friend),
        );
      },
    );
  }

  /// Method 1: Passing data via Navigator.push with constructor parameters
  void _onChatTap(BuildContext context, FriendModel friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(friend: friend),
      ),
    );
  }
}

class FriendCard extends StatelessWidget {
  final FriendModel friend;
  final VoidCallback onChatTap;

  const FriendCard({
    super.key,
    required this.friend,
    required this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  friend.avatar,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Friend info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    friend.mbtiType,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    friend.status,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Chat button
            IconButton(
              onPressed: onChatTap,
              icon: const Icon(
                Icons.chat,
                color: Colors.blue,
                size: 28,
              ),
              tooltip: 'Start chat with ${friend.name}',
            ),
          ],
        ),
      ),
    );
  }
}