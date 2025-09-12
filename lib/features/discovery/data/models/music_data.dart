/// Music story data model for MBTI Explorer app
/// Represents music-related data for music story creation
class MusicSong {
  final String title;
  final String artist;
  final String mood;
  final String genre;
  final String duration;
  final double energy;

  MusicSong({
    required this.title,
    required this.artist,
    required this.mood,
    required this.genre,
    required this.duration,
    required this.energy,
  });

  factory MusicSong.fromJson(Map<String, dynamic> json) {
    return MusicSong(
      title: json['title'],
      artist: json['artist'],
      mood: json['mood'],
      genre: json['genre'],
      duration: json['duration'],
      energy: json['energy'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'mood': mood,
      'genre': genre,
      'duration': duration,
      'energy': energy,
    };
  }
}

/// Music data provider with static methods
class MusicData {
  static const List<String> moods = [
    'Energetic',
    'Calm',
    'Happy',
    'Sad',
    'Romantic',
    'Mysterious',
    'Inspiring',
  ];

  static const List<String> genres = [
    'Pop',
    'Rock',
    'Hip Hop',
    'Electronic',
    'Classical',
    'Jazz',
    'R&B',
    'Country',
  ];

  static List<MusicSong> getRecommendedSongs() {
    return [
      MusicSong(
        title: 'Blinding Lights',
        artist: 'The Weeknd',
        mood: 'Energetic',
        genre: 'Pop',
        duration: '3:20',
        energy: 0.8,
      ),
      MusicSong(
        title: 'Bohemian Rhapsody',
        artist: 'Queen',
        mood: 'Energetic',
        genre: 'Rock',
        duration: '5:55',
        energy: 0.9,
      ),
      MusicSong(
        title: 'Shape of You',
        artist: 'Ed Sheeran',
        mood: 'Happy',
        genre: 'Pop',
        duration: '3:53',
        energy: 0.6,
      ),
      MusicSong(
        title: 'Someone Like You',
        artist: 'Adele',
        mood: 'Sad',
        genre: 'Pop',
        duration: '4:45',
        energy: 0.2,
      ),
      MusicSong(
        title: 'Perfect',
        artist: 'Ed Sheeran',
        mood: 'Romantic',
        genre: 'Pop',
        duration: '4:23',
        energy: 0.4,
      ),
      MusicSong(
        title: 'Hotel California',
        artist: 'Eagles',
        mood: 'Mysterious',
        genre: 'Rock',
        duration: '6:30',
        energy: 0.7,
      ),
      MusicSong(
        title: 'Eye of the Tiger',
        artist: 'Survivor',
        mood: 'Inspiring',
        genre: 'Rock',
        duration: '4:03',
        energy: 0.9,
      ),
      MusicSong(
        title: 'Weightless',
        artist: 'Marconi Union',
        mood: 'Calm',
        genre: 'Electronic',
        duration: '8:08',
        energy: 0.1,
      ),
      MusicSong(
        title: 'Uptown Funk',
        artist: 'Mark Ronson ft. Bruno Mars',
        mood: 'Energetic',
        genre: 'Funk',
        duration: '4:30',
        energy: 0.85,
      ),
      MusicSong(
        title: 'Thinking Out Loud',
        artist: 'Ed Sheeran',
        mood: 'Romantic',
        genre: 'Pop',
        duration: '4:41',
        energy: 0.3,
      ),
    ];
  }

  static List<MusicSong> getSongsByMood(String mood) {
    return getRecommendedSongs().where((song) => song.mood == mood).toList();
  }

  static List<MusicSong> getSongsByGenre(String genre) {
    return getRecommendedSongs().where((song) => song.genre == genre).toList();
  }
}