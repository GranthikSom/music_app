class Song {
  final String id;
  final String title;
  final String artist;
  final String? audioUrl;
  final String? coverUrl;
  final int? durationSeconds;
  final String? genre;
  final String? userId;
  final DateTime createdAt;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    this.audioUrl,
    this.coverUrl,
    this.durationSeconds,
    this.genre,
    this.userId,
    required this.createdAt,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      audioUrl: json['audio_url'],
      coverUrl: json['cover_url'],
      durationSeconds: json['duration_seconds'],
      genre: json['genre'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'audio_url': audioUrl,
      'cover_url': coverUrl,
      'duration_seconds': durationSeconds,
      'genre': genre,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
