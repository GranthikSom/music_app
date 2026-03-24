enum UserRole { user, artist, admin }

class User {
  final String id;
  final String email;
  final String passwordHash;
  final String username;
  final String? avatarUrl;
  final UserRole role;
  final String? bio;
  final bool isVerified;
  final int songCount;
  final int followerCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.username,
    this.avatarUrl,
    this.role = UserRole.user,
    this.bio,
    this.isVerified = false,
    this.songCount = 0,
    this.followerCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      passwordHash: json['password_hash'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      role: _parseRole(json['role']),
      bio: json['bio'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      songCount: json['song_count'] as int? ?? 0,
      followerCount: json['follower_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static UserRole _parseRole(dynamic role) {
    if (role == null) return UserRole.user;
    if (role == 'admin') return UserRole.admin;
    if (role == 'artist') return UserRole.artist;
    return UserRole.user;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password_hash': passwordHash,
      'username': username,
      'avatar_url': avatarUrl,
      'role': role.name,
      'bio': bio,
      'is_verified': isVerified,
      'song_count': songCount,
      'follower_count': followerCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? passwordHash,
    String? username,
    String? avatarUrl,
    UserRole? role,
    String? bio,
    bool? isVerified,
    int? songCount,
    int? followerCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      isVerified: isVerified ?? this.isVerified,
      songCount: songCount ?? this.songCount,
      followerCount: followerCount ?? this.followerCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toPublicJson() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'role': role.name,
      'bio': bio,
      'is_verified': isVerified,
      'song_count': songCount,
      'follower_count': followerCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
