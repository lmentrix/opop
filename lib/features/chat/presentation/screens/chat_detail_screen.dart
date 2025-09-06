import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/datasources/chat_dummy_data.dart';
import '../../data/models/chat_conversation.dart';
import '../../data/models/chat_message.dart' as local_models;
import '../widgets/chat_input_field.dart';
import '../widgets/chat_message_bubble.dart';

/// Chat detail screen for MBTI Explorer app
/// Displays conversation messages and allows user input
class ChatDetailScreen extends StatefulWidget {
  final ChatConversation conversation;

  const ChatDetailScreen({super.key, required this.conversation});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<local_models.ChatMessage> _messages = [];

  bool _isLoading = false;
  bool _isTyping = false;
  late AnimationController _typingController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _typingController, curve: Curves.easeInOut),
    );

    _loadMessages();
    _startTypingAnimation();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _typingController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _messages = ChatDummyData.getMessagesForConversation(
            widget.conversation.id,
          );
          _isLoading = false;
        });

        // Scroll to bottom after messages load
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });
  }

  void _startTypingAnimation() {
    _typingController.repeat(reverse: true);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onSendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Add user message
    final userMessage = local_models.ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'user',
      senderName: 'You',
      senderAvatar: '👤',
      content: message,
      timestamp: DateTime.now(),
      type: local_models.MessageType.text,
      isRead: true,
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate bot response
    _simulateBotResponse(message);
  }

  void _onImageSelected(String imagePath, String fileName) {
    // Create image message
    final imageMessage = local_models.ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'user',
      senderName: 'You',
      senderAvatar: '👤',
      content: imagePath, // Store the full image path in content
      timestamp: DateTime.now(),
      type: local_models.MessageType.image,
      isRead: true,
      metadata: {'fileName': fileName, 'imagePath': imagePath},
    );

    setState(() {
      _messages.add(imageMessage);
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate bot response to image
    _simulateBotResponseToImage(fileName);
  }

  void _simulateBotResponseToImage(String fileName) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        final responses = [
          'Nice image! I can see you shared "$fileName".',
          'That\'s an interesting photo! What made you want to share it?',
          'I received your image. How does this relate to your personality type?',
          'Thanks for sharing that image! Can you tell me more about it?',
        ];

        final randomResponse =
            responses[DateTime.now().millisecond % responses.length];

        final botMessage = local_models.ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: widget.conversation.participantIds.firstWhere(
            (id) => id != 'user',
            orElse: () => 'bot',
          ),
          senderName: widget.conversation.lastSenderName,
          senderAvatar: widget.conversation.lastSenderAvatar,
          content: randomResponse,
          timestamp: DateTime.now(),
          type: local_models.MessageType.text,
          isRead: false,
        );

        setState(() {
          _messages.add(botMessage);
        });
        _scrollToBottom();
      }
    });
  }

  void _simulateBotResponse(String userMessage) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        final botMessage = _generateBotResponse(userMessage);
        setState(() {
          _messages.add(botMessage);
        });
        _scrollToBottom();
      }
    });
  }

  local_models.ChatMessage _generateBotResponse(String userMessage) {
    final responses = [
      'That\'s a great question! Let me think about that...',
      'I understand what you\'re asking. Here\'s what I think...',
      'Interesting perspective! Based on MBTI theory...',
      'Let me help you explore that further...',
      'That relates to what we discussed earlier...',
    ];

    final randomResponse =
        responses[DateTime.now().millisecond % responses.length];

    return local_models.ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: widget.conversation.participantIds.firstWhere(
        (id) => id != 'user',
        orElse: () => 'bot',
      ),
      senderName: widget.conversation.lastSenderName,
      senderAvatar: widget.conversation.lastSenderAvatar,
      content: randomResponse,
      timestamp: DateTime.now(),
      type: local_models.MessageType.text,
      isRead: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [_buildAppBar(), _buildMessageList(), _buildInputSection()],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: AppSpacing.iconSize,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          CircleAvatar(
            radius: 20,
            backgroundColor: _getAvatarColor(),
            child: Text(
              widget.conversation.lastSenderAvatar,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textInverse,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.conversation.title,
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _getStatusText(),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildMoreOptions(),
        ],
      ),
    );
  }

  Widget _buildMoreOptions() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: AppColors.textSecondary,
        size: AppSpacing.iconSize,
      ),
      onSelected: (value) {
        switch (value) {
          case 'clear':
            _showClearChatDialog();
            break;
          case 'info':
            _showConversationInfo();
            break;
        }
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: 'info',
              child: Row(
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: AppSpacing.sm),
                  Text('Conversation Info'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(Icons.clear_all),
                  SizedBox(width: AppSpacing.sm),
                  Text('Clear Chat'),
                ],
              ),
            ),
          ],
    );
  }

  Widget _buildMessageList() {
    if (_isLoading) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Loading messages...',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_messages.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: AppColors.textDisabled,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No messages yet',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Start the conversation!',
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
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: _messages.length + (_isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _messages.length && _isTyping) {
            return _buildTypingIndicator();
          }

          final message = _messages[index];
          final isUser = message.senderId == 'user';
          final showAvatar =
              !isUser &&
              (index == 0 || _messages[index - 1].senderId != message.senderId);

          return ChatMessageBubble(
            message: message,
            isUser: isUser,
            showAvatar: showAvatar,
            showTime:
                index == _messages.length - 1 ||
                _messages[index + 1].senderId != message.senderId,
          );
        },
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.screenPadding,
        bottom: AppSpacing.md,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: _getAvatarColor(),
            child: Text(
              widget.conversation.lastSenderAvatar,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textInverse,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: _typingAnimation,
      builder: (context, child) {
        final delay = index * 0.2;
        final opacity = (_typingAnimation.value + delay) % 1.0;

        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withOpacity(opacity),
            borderRadius: BorderRadius.circular(AppSpacing.full),
          ),
        );
      },
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ChatInputField(
        controller: _messageController,
        focusNode: _focusNode,
        onSend: _onSendMessage,
        hintText: 'Type a message...',
        onFileSelected: _onImageSelected,
      ),
    );
  }

  Color _getAvatarColor() {
    switch (widget.conversation.type) {
      case ConversationType.assessment:
        return AppColors.analyst;
      case ConversationType.personality:
        return AppColors.diplomat;
      case ConversationType.support:
        return AppColors.sentinel;
      case ConversationType.group:
        return AppColors.explorer;
      case ConversationType.system:
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }

  String _getStatusText() {
    if (_isTyping) return 'typing...';

    final lastMessage = _messages.isNotEmpty ? _messages.last : null;
    if (lastMessage != null && lastMessage.senderId != 'user') {
      return 'last seen ${_formatTime(lastMessage.timestamp)}';
    }

    return 'online';
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Chat'),
            content: const Text(
              'Are you sure you want to clear all messages? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _messages.clear();
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Clear', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
    );
  }

  void _showConversationInfo() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(widget.conversation.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${_getConversationTypeName()}'),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Participants: ${widget.conversation.participantIds.length}',
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Created: ${_formatDate(widget.conversation.createdAt)}'),
                const SizedBox(height: AppSpacing.sm),
                Text('Messages: ${_messages.length}'),
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

  String _getConversationTypeName() {
    switch (widget.conversation.type) {
      case ConversationType.assessment:
        return 'Assessment';
      case ConversationType.personality:
        return 'Personality';
      case ConversationType.support:
        return 'Support';
      case ConversationType.group:
        return 'Group';
      case ConversationType.system:
        return 'System';
      default:
        return 'Personal';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
