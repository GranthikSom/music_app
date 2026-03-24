import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (envUrl.isNotEmpty) return envUrl;
    return 'http://localhost:8080';
  }

  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static void clearToken() {
    _token = null;
  }

  static Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Auth
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'username': username,
      }),
    );
    if (res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception(jsonDecode(res.body)['error'] ?? 'Registration failed');
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception(jsonDecode(res.body)['error'] ?? 'Login failed');
  }

  // Songs
  static Future<List<dynamic>> getSongs() async {
    final res = await http.get(Uri.parse('$baseUrl/songs'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to fetch songs');
  }

  static Future<dynamic> getSong(String id) async {
    final res = await http.get(Uri.parse('$baseUrl/songs/$id'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Song not found');
  }

  static Future<List<dynamic>> searchSongs(String query) async {
    final res = await http.get(Uri.parse('$baseUrl/songs/search?q=$query'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Search failed');
  }

  static Future<List<dynamic>> searchSongsWithFilters({
    String? query,
    String? genre,
    String sortBy = 'date',
    String sortOrder = 'desc',
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final params = <String, String>{};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (genre != null && genre.isNotEmpty) params['genre'] = genre;
    params['sort'] = sortBy;
    params['order'] = sortOrder;
    if (fromDate != null) params['from'] = fromDate.toIso8601String();
    if (toDate != null) params['to'] = toDate.toIso8601String();

    final uri = Uri.parse(
      '$baseUrl/songs/search',
    ).replace(queryParameters: params);
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Search with filters failed');
  }

  static Future<List<String>> getGenres() async {
    final res = await http.get(Uri.parse('$baseUrl/songs/genres'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => e.toString()).toList();
    }
    throw Exception('Failed to fetch genres');
  }

  static Future<dynamic> createSong({
    required String title,
    required String artist,
    String? audioUrl,
    String? coverUrl,
    int? durationSeconds,
    String? genre,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/songs/create'),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'artist': artist,
        'audio_url': audioUrl,
        'cover_url': coverUrl,
        'duration_seconds': durationSeconds,
        'genre': genre,
      }),
    );
    if (res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception(jsonDecode(res.body)['error'] ?? 'Failed to create song');
  }

  // Playlists
  static Future<List<dynamic>> getPlaylists() async {
    final res = await http.get(Uri.parse('$baseUrl/playlists'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to fetch playlists');
  }

  static Future<dynamic> createPlaylist({
    required String name,
    String? description,
    bool isPublic = true,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/playlists'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'description': description,
        'is_public': isPublic,
      }),
    );
    if (res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to create playlist');
  }

  static Future<dynamic> updatePlaylist(
    String id, {
    String? name,
    String? description,
  }) async {
    final res = await http.put(
      Uri.parse('$baseUrl/playlists/$id'),
      headers: _headers,
      body: jsonEncode({
        if (name != null) 'name': name,
        if (description != null) 'description': description,
      }),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to update playlist');
  }

  static Future<void> deletePlaylist(String id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/playlists/$id'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to delete playlist');
    }
  }

  // Favorites
  static Future<List<dynamic>> getFavorites() async {
    final res = await http.get(
      Uri.parse('$baseUrl/favorites'),
      headers: _headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to fetch favorites');
  }

  static Future<void> toggleFavorite(String songId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/favorites/$songId'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to toggle favorite');
    }
  }

  // File Upload
  static Future<Map<String, dynamic>> uploadAudio(String filePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload/audio'),
    );
    request.headers['Authorization'] = 'Bearer $_token';
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final res = await request.send();
    final body = await res.stream.bytesToString();
    if (res.statusCode == 200) {
      return jsonDecode(body);
    }
    throw Exception('Failed to upload audio');
  }

  static Future<Map<String, dynamic>> uploadCover(String filePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload/cover'),
    );
    request.headers['Authorization'] = 'Bearer $_token';
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final res = await request.send();
    final body = await res.stream.bytesToString();
    if (res.statusCode == 200) {
      return jsonDecode(body);
    }
    throw Exception('Failed to upload cover');
  }

  // Admin
  static Future<Map<String, dynamic>> getAdminStats() async {
    final res = await http.get(
      Uri.parse('$baseUrl/admin/stats'),
      headers: _headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to fetch admin stats');
  }

  static Future<List<dynamic>> getAdminUsers() async {
    final res = await http.get(
      Uri.parse('$baseUrl/admin/users'),
      headers: _headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to fetch users');
  }

  static Future<void> deleteUser(String userId) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/admin/users/$userId'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  // Artists
  static Future<List<dynamic>> getArtists() async {
    final res = await http.get(Uri.parse('$baseUrl/artists'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to fetch artists');
  }

  static Future<Map<String, dynamic>> getArtistProfile(String artistId) async {
    final res = await http.get(Uri.parse('$baseUrl/artists/$artistId'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to fetch artist profile');
  }

  static Future<void> updateArtistProfile({
    required String artistId,
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    final res = await http.put(
      Uri.parse('$baseUrl/artists/$artistId/update'),
      headers: _headers,
      body: jsonEncode({
        if (username != null) 'username': username,
        if (bio != null) 'bio': bio,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  // Social - Follow
  static Future<List<dynamic>> getFollowers({String? userId}) async {
    final res = await http.get(
      Uri.parse('$baseUrl/follow?type=followers'),
      headers: _headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to fetch followers');
  }

  static Future<List<dynamic>> getFollowing({String? userId}) async {
    final res = await http.get(
      Uri.parse('$baseUrl/follow?type=following'),
      headers: _headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to fetch following');
  }

  static Future<Map<String, dynamic>> toggleFollow(String userId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/follow/$userId'),
      headers: _headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to toggle follow');
  }

  // Recommendations
  static Future<Map<String, dynamic>> getRecommendations() async {
    final res = await http.get(Uri.parse('$baseUrl/recommendations'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to fetch recommendations');
  }

  static Future<List<dynamic>> getSimilarSongs(String songId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/recommendations/similar/$songId'),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to fetch similar songs');
  }
}
