// lib/features/profile/presentation/providers/profile_provider.dart

import 'package:flutter/foundation.dart';

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

  void changeAvatar(String avatar) {
    _selectedAvatar = avatar;
    notifyListeners();
  }
}
