import 'dart:convert';
import 'dart:io';
import '../models/user.dart';
import '../models/song.dart';
import '../models/playlist.dart';
import '../models/favorite.dart';
import '../models/follow.dart';

class DataStore {
  static final DataStore _instance = DataStore._internal();
  factory DataStore() => _instance;
  DataStore._internal();

  final String _dataPath = 'data';
  final String _uploadsPath = 'uploads';

  Map<String, User> _users = {};
  Map<String, Song> _songs = {};
  Map<String, Playlist> _playlists = {};
  Map<String, Favorite> _favorites = {};
  Map<String, Follow> _follows = {};

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await Directory(_dataPath).create(recursive: true);
    await Directory('$_uploadsPath/audio').create(recursive: true);
    await Directory('$_uploadsPath/covers').create(recursive: true);

    await _loadUsers();
    await _loadSongs();
    await _loadPlaylists();
    await _loadFavorites();
    await _loadFollows();
    _initialized = true;
  }

  // Users
  Future<void> _loadUsers() async {
    final file = File('$_dataPath/users.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> data = jsonDecode(content) as List<dynamic>;
      _users = {
        for (var u in data)
          (u as Map<String, dynamic>)['id'] as String: User.fromJson(u),
      };
    }
  }

  Future<void> _saveUsers() async {
    final file = File('$_dataPath/users.json');
    await file.writeAsString(
      jsonEncode(_users.values.map((u) => u.toJson()).toList()),
    );
  }

  Future<User?> findUserByEmail(String email) async {
    return _users.values.cast<User?>().firstWhere(
      (u) => u?.email == email,
      orElse: () => null,
    );
  }

  Future<User?> findUserById(String id) async {
    return _users[id];
  }

  Future<void> createUser(User user) async {
    _users[user.id] = user;
    await _saveUsers();
  }

  Future<void> updateUser(User user) async {
    _users[user.id] = user;
    await _saveUsers();
  }

  List<User> getAllUsers() {
    return _users.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<User> getArtists() {
    return _users.values.where((u) => u.role.name == 'artist').toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> deleteUser(String id) async {
    _users.remove(id);
    await _saveUsers();
  }

  // Songs
  Future<void> _loadSongs() async {
    final file = File('$_dataPath/songs.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final data = jsonDecode(content) as List<dynamic>;
      _songs = {
        for (var s in data)
          (s as Map<String, dynamic>)['id'] as String: Song.fromJson(s),
      };
    }
  }

  Future<void> _saveSongs() async {
    final file = File('$_dataPath/songs.json');
    await file.writeAsString(
      jsonEncode(_songs.values.map((s) => s.toJson()).toList()),
    );
  }

  List<Song> getAllSongs() {
    return _songs.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Song? getSongById(String id) => _songs[id];

  List<Song> searchSongs(
    String query, {
    String? genre,
    String sortBy = 'date',
    bool descending = true,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    var results = _songs.values.toList();

    // Text search filter
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      results = results
          .where(
            (s) =>
                s.title.toLowerCase().contains(q) ||
                s.artist.toLowerCase().contains(q),
          )
          .toList();
    }

    // Genre filter
    if (genre != null && genre.isNotEmpty) {
      results = results
          .where((s) => s.genre?.toLowerCase() == genre.toLowerCase())
          .toList();
    }

    // Date range filter
    if (fromDate != null) {
      results = results
          .where(
            (s) =>
                s.createdAt.isAfter(fromDate) ||
                s.createdAt.isAtSameMomentAs(fromDate),
          )
          .toList();
    }
    if (toDate != null) {
      results = results
          .where(
            (s) =>
                s.createdAt.isBefore(toDate) ||
                s.createdAt.isAtSameMomentAs(toDate),
          )
          .toList();
    }

    // Sorting
    switch (sortBy.toLowerCase()) {
      case 'title':
        results.sort(
          (a, b) => descending
              ? b.title.toLowerCase().compareTo(a.title.toLowerCase())
              : a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case 'artist':
        results.sort(
          (a, b) => descending
              ? b.artist.toLowerCase().compareTo(a.artist.toLowerCase())
              : a.artist.toLowerCase().compareTo(b.artist.toLowerCase()),
        );
        break;
      case 'date':
      default:
        results.sort(
          (a, b) => descending
              ? b.createdAt.compareTo(a.createdAt)
              : a.createdAt.compareTo(b.createdAt),
        );
        break;
    }

    return results;
  }

  List<String> getGenres() {
    final genres = _songs.values
        .where((s) => s.genre != null && s.genre!.isNotEmpty)
        .map((s) => s.genre!)
        .toSet()
        .toList();
    genres.sort();
    return genres;
  }

  Future<Song> createSong(Song song) async {
    _songs[song.id] = song;
    await _saveSongs();
    return song;
  }

  Future<void> deleteSong(String id) async {
    final song = _songs[id];
    if (song != null) {
      _songs.remove(id);
      await _saveSongs();

      // Remove from favorites
      final favsToRemove = _favorites.entries
          .where((e) => e.value.songId == id)
          .map((e) => e.key)
          .toList();
      for (final key in favsToRemove) {
        _favorites.remove(key);
      }
      await _saveFavorites();

      // Remove from playlists
      for (final p in _playlists.values) {
        if (p.songIds.contains(id)) {
          final updated = p.copyWith(
            songIds: p.songIds.where((s) => s != id).toList(),
            updatedAt: DateTime.now(),
          );
          _playlists[updated.id] = updated;
        }
      }
      await _savePlaylists();
    }
  }

  // Playlists
  Future<void> _loadPlaylists() async {
    final file = File('$_dataPath/playlists.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final data = jsonDecode(content) as List<dynamic>;
      _playlists = {
        for (var p in data)
          (p as Map<String, dynamic>)['id'] as String: Playlist.fromJson(p),
      };
    }
  }

  Future<void> _savePlaylists() async {
    final file = File('$_dataPath/playlists.json');
    await file.writeAsString(
      jsonEncode(_playlists.values.map((p) => p.toJson()).toList()),
    );
  }

  List<Playlist> getAllPlaylists({String? userId}) {
    var playlists = _playlists.values.toList();
    if (userId != null) {
      playlists = playlists
          .where((p) => p.userId == userId || p.isPublic)
          .toList();
    } else {
      playlists = playlists.where((p) => p.isPublic).toList();
    }
    return playlists..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Playlist? getPlaylistById(String id) => _playlists[id];

  Future<Playlist> createPlaylist(Playlist playlist) async {
    _playlists[playlist.id] = playlist;
    await _savePlaylists();
    return playlist;
  }

  Future<void> updatePlaylist(Playlist playlist) async {
    _playlists[playlist.id] = playlist;
    await _savePlaylists();
  }

  Future<void> deletePlaylist(String id) async {
    _playlists.remove(id);
    await _savePlaylists();
  }

  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    final playlist = _playlists[playlistId];
    if (playlist != null && !playlist.songIds.contains(songId)) {
      final updated = playlist.copyWith(
        songIds: [...playlist.songIds, songId],
        updatedAt: DateTime.now(),
      );
      _playlists[playlistId] = updated;
      await _savePlaylists();
    }
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    final playlist = _playlists[playlistId];
    if (playlist != null) {
      final updated = playlist.copyWith(
        songIds: playlist.songIds.where((id) => id != songId).toList(),
        updatedAt: DateTime.now(),
      );
      _playlists[playlistId] = updated;
      await _savePlaylists();
    }
  }

  // Favorites
  Future<void> _loadFavorites() async {
    final file = File('$_dataPath/favorites.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final data = jsonDecode(content) as List<dynamic>;
      _favorites = {
        for (final f in data)
          '${f['user_id']}_${f['song_id']}': Favorite.fromJson(
            f as Map<String, dynamic>,
          ),
      };
    }
  }

  Future<void> _saveFavorites() async {
    final file = File('$_dataPath/favorites.json');
    await file.writeAsString(
      jsonEncode(_favorites.values.map((f) => f.toJson()).toList()),
    );
  }

  List<Favorite> getUserFavorites(String userId) {
    return _favorites.values.where((f) => f.userId == userId).toList();
  }

  bool isFavorite(String userId, String songId) {
    return _favorites.containsKey('${userId}_$songId');
  }

  Future<void> toggleFavorite(String userId, String songId) async {
    final key = '${userId}_$songId';
    if (_favorites.containsKey(key)) {
      _favorites.remove(key);
    } else {
      _favorites[key] = Favorite(
        userId: userId,
        songId: songId,
        createdAt: DateTime.now(),
      );
    }
    await _saveFavorites();
  }

  // Follows
  Future<void> _loadFollows() async {
    final file = File('$_dataPath/follows.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final data = jsonDecode(content) as List<dynamic>;
      _follows = {
        for (var f in data)
          '${f['follower_id']}_${f['following_id']}': Follow.fromJson(
            f as Map<String, dynamic>,
          ),
      };
    }
  }

  Future<void> _saveFollows() async {
    final file = File('$_dataPath/follows.json');
    await file.writeAsString(
      jsonEncode(_follows.values.map((f) => f.toJson()).toList()),
    );
  }

  List<Follow> getFollowers(String userId) {
    return _follows.values.where((f) => f.followingId == userId).toList();
  }

  List<Follow> getFollowing(String userId) {
    return _follows.values.where((f) => f.followerId == userId).toList();
  }

  int getFollowerCount(String userId) {
    return _follows.values.where((f) => f.followingId == userId).length;
  }

  int getFollowingCount(String userId) {
    return _follows.values.where((f) => f.followerId == userId).length;
  }

  bool isFollowing(String followerId, String followingId) {
    return _follows.containsKey('${followerId}_$followingId');
  }

  Future<void> toggleFollow(String followerId, String followingId) async {
    final key = '${followerId}_$followingId';
    if (followerId == followingId) return;

    if (_follows.containsKey(key)) {
      _follows.remove(key);
    } else {
      _follows[key] = Follow(
        followerId: followerId,
        followingId: followingId,
        createdAt: DateTime.now(),
      );
    }
    await _saveFollows();
  }
}
