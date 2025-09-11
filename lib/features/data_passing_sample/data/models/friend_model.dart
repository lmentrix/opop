/// Friend model for data passing demonstration
/// This model shows how to structure data for passing between screens
class FriendModel {
  final String id;
  final String name;
  final String mbtiType;
  final String avatar;
  final String status;
  final String personalityDescription;

  FriendModel({
    required this.id,
    required this.name,
    required this.mbtiType,
    required this.avatar,
    required this.status,
    required this.personalityDescription,
  });

  /// Factory constructor to create from JSON
  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id'] as String,
      name: json['name'] as String,
      mbtiType: json['mbtiType'] as String,
      avatar: json['avatar'] as String,
      status: json['status'] as String,
      personalityDescription: json['personalityDescription'] as String,
    );
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mbtiType': mbtiType,
      'avatar': avatar,
      'status': status,
      'personalityDescription': personalityDescription,
    };
  }

  /// Create a copy with updated values
  FriendModel copyWith({
    String? id,
    String? name,
    String? mbtiType,
    String? avatar,
    String? status,
    String? personalityDescription,
  }) {
    return FriendModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mbtiType: mbtiType ?? this.mbtiType,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      personalityDescription:
          personalityDescription ?? this.personalityDescription,
    );
  }

  @override
  String toString() {
    return 'FriendModel(name: $name, mbtiType: $mbtiType, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FriendModel &&
        other.id == id &&
        other.name == name &&
        other.mbtiType == mbtiType;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ mbtiType.hashCode;
}
