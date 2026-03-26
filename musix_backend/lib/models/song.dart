class Song {
  final String id;
  final String title;
  final String artist;
  final String audioUrl;
  final String? coverUrl;
  final int? durationSeconds;
  final String? genre;
  final String userId;
  final DateTime createdAt;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioUrl,
    this.coverUrl,
    this.durationSeconds,
    this.genre,
    required this.userId,
    required this.createdAt,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      audioUrl: json['audio_url'] as String,
      coverUrl: json['cover_url'] as String?,
      durationSeconds: json['duration_seconds'] as int?,
      genre: json['genre'] as String?,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
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

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? audioUrl,
    String? coverUrl,
    int? durationSeconds,
    String? genre,
    String? userId,
    DateTime? createdAt,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      audioUrl: audioUrl ?? this.audioUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      genre: genre ?? this.genre,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
