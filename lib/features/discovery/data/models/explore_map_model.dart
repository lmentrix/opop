import 'package:latlong2/latlong.dart';

class NearbyPerson {
  final String id;
  final String name;
  final String avatar;
  final String mbtiType;
  final String status;
  final double distance;
  final LatLng position;
  final String? personalityDescription;
  final bool isOnline;

  NearbyPerson({
    required this.id,
    required this.name,
    required this.avatar,
    required this.mbtiType,
    required this.status,
    required this.distance,
    required this.position,
    this.personalityDescription,
    this.isOnline = true,
  });

  factory NearbyPerson.fromJson(Map<String, dynamic> json) {
    return NearbyPerson(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      mbtiType: json['mbtiType'],
      status: json['status'],
      distance: json['distance'].toDouble(),
      position: LatLng(
        json['latitude'],
        json['longitude'],
      ),
      personalityDescription: json['personalityDescription'],
      isOnline: json['isOnline'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'mbtiType': mbtiType,
      'status': status,
      'distance': distance,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'personalityDescription': personalityDescription,
      'isOnline': isOnline,
    };
  }
}

class ExploreMapData {
  static const LatLng vancouverCenter = LatLng(49.2827, -123.1207);
  
  static List<NearbyPerson> getDummyNearbyPeople() {
    return [
      NearbyPerson(
        id: '1',
        name: 'Sarah Chen',
        avatar: 'assets/avatars/sarah.png',
        mbtiType: 'INFJ',
        status: 'Exploring downtown',
        distance: 0.5,
        position: const LatLng(49.2830, -123.1200),
        personalityDescription: 'Creative thinker who loves deep conversations',
        isOnline: true,
      ),
      NearbyPerson(
        id: '2',
        name: 'Marcus Rodriguez',
        avatar: 'assets/avatars/marcus.png',
        mbtiType: 'ENTP',
        status: 'At coffee shop',
        distance: 1.2,
        position: const LatLng(49.2845, -123.1150),
        personalityDescription: 'Innovative debater with entrepreneurial spirit',
        isOnline: true,
      ),
      NearbyPerson(
        id: '3',
        name: 'Emily Watson',
        avatar: 'assets/avatars/emily.png',
        mbtiType: 'ISFP',
        status: 'Art gallery visit',
        distance: 2.1,
        position: const LatLng(49.2780, -123.1250),
        personalityDescription: 'Artistic soul with a passion for creativity',
        isOnline: false,
      ),
      NearbyPerson(
        id: '4',
        name: 'David Kim',
        avatar: 'assets/avatars/david.png',
        mbtiType: 'INTJ',
        status: 'Library study session',
        distance: 3.5,
        position: const LatLng(49.2790, -123.1300),
        personalityDescription: 'Strategic planner with analytical mind',
        isOnline: true,
      ),
      NearbyPerson(
        id: '5',
        name: 'Lisa Thompson',
        avatar: 'assets/avatars/lisa.png',
        mbtiType: 'ENFJ',
        status: 'Community meetup',
        distance: 1.8,
        position: const LatLng(49.2860, -123.1180),
        personalityDescription: 'Natural leader who brings people together',
        isOnline: true,
      ),
      NearbyPerson(
        id: '6',
        name: 'Alex Morgan',
        avatar: 'assets/avatars/alex.png',
        mbtiType: 'ISTP',
        status: 'Mountain biking',
        distance: 4.2,
        position: const LatLng(49.2900, -123.1250),
        personalityDescription: 'Adventurous problem-solver',
        isOnline: false,
      ),
      NearbyPerson(
        id: '7',
        name: 'Rachel Green',
        avatar: 'assets/avatars/rachel.png',
        mbtiType: 'ESFJ',
        status: 'Shopping downtown',
        distance: 0.8,
        position: const LatLng(49.2810, -123.1220),
        personalityDescription: 'Caring organizer who loves helping others',
        isOnline: true,
      ),
      NearbyPerson(
        id: '8',
        name: 'James Wilson',
        avatar: 'assets/avatars/james.png',
        mbtiType: 'INFP',
        status: 'Bookstore browsing',
        distance: 1.5,
        position: const LatLng(49.2850, -123.1160),
        personalityDescription: 'Idealistic dreamer with creative vision',
        isOnline: true,
      ),
    ];
  }
  
  static String getMBTIColor(String mbtiType) {
    switch (mbtiType.substring(0, 2)) {
      case 'IN':
        return '#9C27B0'; // Purple for Introverted Intuitive
      case 'EN':
        return '#00BCD4'; // Cyan for Extraverted Intuitive
      case 'IS':
        return '#4CAF50'; // Green for Introverted Sensing
      case 'ES':
        return '#FFC107'; // Amber for Extraverted Sensing
      default:
        return '#2196F3'; // Blue default
    }
  }
}