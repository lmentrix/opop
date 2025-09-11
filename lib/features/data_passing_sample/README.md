# Data Passing Sample for Flutter

This folder demonstrates how to pass text data from one screen to another in Flutter, using the example of passing friend data (like "Emma Davis") from a friends list to a chat detail screen.

## 📁 File Structure

```
data_passing_sample/
├── data/
│   └── models/
│       └── friend_model.dart      # Data model for friend information
├── presentation/
│   └── screens/
│       ├── friends_list_screen.dart    # Source screen (sends data)
│       └── chat_detail_screen.dart     # Destination screen (receives data)
└── README.md                           # This file
```

## 🎯 Example Use Case

When you click the chat icon next to "Emma Davis" in the friends list, her data (name, MBTI type, avatar, status, etc.) is passed to the chat detail screen and displayed there.

## 🔄 Data Passing Methods Demonstrated

### Method 1: Constructor Parameters (Recommended)

**Source Screen:**
```dart
void _onChatTap(BuildContext context, FriendModel friend) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatDetailScreen(friend: friend),
    ),
  );
}
```

**Destination Screen:**
```dart
class ChatDetailScreen extends StatelessWidget {
  final FriendModel friend;

  const ChatDetailScreen({
    super.key,
    required this.friend,
  });

  @override
  Widget build(BuildContext context) {
    // Access friend.name, friend.mbtiType, etc.
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${friend.name}'),
      ),
    );
  }
}
```

### Method 2: Route Arguments (Alternative)

**Source Screen:**
```dart
Navigator.pushNamed(
  context,
  ChatDetailScreen.routeName,
  arguments: {
    'friend': friend.toJson(),
  },
);
```

**Destination Screen:**
```dart
static const routeName = '/chat-detail';

static ChatDetailScreen fromRoute(BuildContext context) {
  final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  return ChatDetailScreen(
    friend: FriendModel.fromJson(args['friend']),
  );
}
```

## 📊 Data Model Structure

The `FriendModel` class demonstrates how to structure data for passing:

```dart
class FriendModel {
  final String id;
  final String name;           // e.g., "Emma Davis"
  final String mbtiType;       // e.g., "INFJ" 
  final String avatar;          // e.g., "👩‍🎨"
  final String status;          // e.g., "Art gallery visit"
  final String personalityDescription;
}
```

## 🎨 Key Features Demonstrated

1. **Type Safety**: Using a custom model class ensures type safety
2. **Serialization**: `toJson()` and `fromJson()` methods for persistence
3. **Immutability**: Proper use of `final` fields and `copyWith()` method
4. **Null Safety**: All required fields are non-nullable
5. **Object Equality**: Proper `==` operator and `hashCode` implementation

## 🚀 How to Use This Sample

1. **Navigate to Friends List**: 
   ```dart
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => const FriendsListScreen()),
   );
   ```

2. **Click Chat Icon**: This triggers `_onChatTap()` with the friend's data

3. **View Passed Data**: The chat screen displays all received friend information

## 💡 Best Practices Demonstrated

- ✅ Use constructor parameters for simple data passing
- ✅ Create proper data models for complex data
- ✅ Handle null safety properly
- ✅ Use meaningful variable names
- ✅ Add proper documentation
- ✅ Implement proper error handling
- ✅ Use consistent styling

## 🔧 Customization Ideas

1. **Add More Fields**: Extend `FriendModel` with age, location, interests, etc.
2. **Add Images**: Include profile picture URLs
3. **Add Validation**: Add input validation in the model
4. **Add API Integration**: Replace dummy data with real API calls
5. **Add State Management**: Use Provider, Riverpod, or Bloc for state management

## 📱 UI Components Used

- `Card` for friend items
- `ListView.builder` for efficient scrolling
- `AppBar` for navigation
- `AlertDialog` for detailed information
- `TextField` for message input
- `SnackBar` for user feedback

## 🎯 Real-World Applications

This pattern can be used for:
- User profile viewing
- Product details from a list
- Order confirmation from cart
- Settings screens with pre-filled data
- Multi-step forms
- Any master-detail interface

## 🔄 Integration with Existing Code

This sample follows the same pattern used in the main app's friends screen, making it easy to understand how the actual implementation works.

The main difference is that this sample focuses purely on demonstrating data passing concepts without the complexity of the full app's chat system.