import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/song_model.dart';

class SongsProvider with ChangeNotifier {
  List<Song> _songs = [];
  List<String> _genres = [];
  bool _isLoading = false;
  String? _error;
  String? _activeGenre;
  String _sortBy = 'date';
  String _sortOrder = 'desc';
  String? _fromDate;
  String? _toDate;

  List<Song> get songs => _songs;
  List<String> get genres => _genres;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get activeGenre => _activeGenre;
  String get sortBy => _sortBy;
  String get sortOrder => _sortOrder;
  String? get fromDate => _fromDate;
  String? get toDate => _toDate;

  bool get hasActiveFilters =>
      _activeGenre != null ||
      _sortBy != 'date' ||
      _sortOrder != 'desc' ||
      _fromDate != null ||
      _toDate != null;

  Future<void> fetchSongs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.getSongs();
      _songs = data.map((json) => Song.fromJson(json)).toList();
      _songs.shuffle();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchSongs(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.searchSongs(query);
      _songs = data.map((json) => Song.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchWithFilters({
    String? query,
    String? genre,
    String? sortBy,
    String? sortOrder,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    _isLoading = true;
    _error = null;
    if (genre != null) _activeGenre = genre;
    if (sortBy != null) _sortBy = sortBy;
    if (sortOrder != null) _sortOrder = sortOrder;
    _fromDate = fromDate?.toIso8601String();
    _toDate = toDate?.toIso8601String();
    notifyListeners();

    try {
      final data = await ApiService.searchSongsWithFilters(
        query: query,
        genre: genre ?? _activeGenre,
        sortBy: sortBy ?? _sortBy,
        sortOrder: sortOrder ?? _sortOrder,
        fromDate: fromDate,
        toDate: toDate,
      );
      _songs = data.map((json) => Song.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchGenres() async {
    try {
      _genres = await ApiService.getGenres();
      notifyListeners();
    } catch (e) {
      // Silently fail, genres are optional
    }
  }

  void clearFilters() {
    _activeGenre = null;
    _sortBy = 'date';
    _sortOrder = 'desc';
    _fromDate = null;
    _toDate = null;
    notifyListeners();
  }

  void setGenreFilter(String? genre) {
    _activeGenre = genre;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void setSortOrder(String order) {
    _sortOrder = order;
    notifyListeners();
  }

  void setDateRange(DateTime? from, DateTime? to) {
    _fromDate = from?.toIso8601String();
    _toDate = to?.toIso8601String();
    notifyListeners();
  }

  Future<bool> createSong({
    required String title,
    required String artist,
    String? audioUrl,
    String? coverUrl,
    int? durationSeconds,
    String? genre,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await ApiService.createSong(
        title: title,
        artist: artist,
        audioUrl: audioUrl,
        coverUrl: coverUrl,
        durationSeconds: durationSeconds,
        genre: genre,
      );
      final song = Song.fromJson(data);
      _songs.insert(0, song);
      if (genre != null && !_genres.contains(genre)) {
        _genres.add(genre);
        _genres.sort();
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
