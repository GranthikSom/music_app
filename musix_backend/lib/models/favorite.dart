class Favorite {
  final String userId;
  final String songId;
  final DateTime createdAt;

  const Favorite({
    required this.userId,
    required this.songId,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      userId: json['user_id'] as String,
      songId: json['song_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'song_id': songId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
