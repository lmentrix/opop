import 'package:flutter/material.dart';
import '../../../data_passing_sample/data/models/friend_model.dart';

/// Destination screen that receives data from the previous screen
/// This demonstrates multiple ways to receive and display passed data
class ChatDetailScreen extends StatelessWidget {
  // Method 1: Receiving data via constructor parameter (recommended)
  final FriendModel friend;

  const ChatDetailScreen({
    super.key,
    required this.friend,
  });

  // Method 2: Alternative - receiving data via route arguments
  // static const routeName = '/chat-detail';
  // 
  // static ChatDetailScreen fromRoute(BuildContext context) {
  //   final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  //   return ChatDetailScreen(
  //     friend: FriendModel.fromJson(args['friend']),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${friend.name}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        // Method 3: Accessing data from widget properties
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => _showFriendInfo(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Friend info header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              children: [
                // Display received avatar data
                Text(
                  friend.avatar,
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 8),
                
                // Display received name data
                Text(
                  friend.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Display received MBTI type data
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    friend.mbtiType,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Display received status data
                Text(
                  friend.status,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Display received personality description
                Text(
                  friend.personalityDescription,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Chat area
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Chat functionality would go here',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Data received successfully!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Message input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message to ${friend.name}...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // Show that we can access the friend's name here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Message sent to ${friend.name}!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFriendInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(friend.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('ID', friend.id),
            _buildInfoRow('Name', friend.name),
            _buildInfoRow('MBTI Type', friend.mbtiType),
            _buildInfoRow('Avatar', friend.avatar),
            _buildInfoRow('Status', friend.status),
            _buildInfoRow('Description', friend.personalityDescription),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}