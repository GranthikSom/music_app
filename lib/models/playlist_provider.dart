import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/song_data.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlists = [
    Song(
      title: "Starboiiiii",
      artist: "weekdays",
      album: "assets/cover/Starboy.jpg",
      audiopath: "mp4/starboy.mp3",
      quote: "I'm tryna put you in the worst mood, ah",
    ),
    Song(
      title: "Everybody dies",
      artist: "X",
      album: "assets/cover/XXXTentacion.jpg",
      audiopath: "mp4/everybody.mp3",
      quote: "I know you're somewhere, somewhere",
    ),
    Song(
      title: "Wild Flowers",
      artist: "Billie Eilish",
      album: "assets/cover/Billieeilish.jpeg",
      audiopath: "mp4/wildflower.mp3",
      quote: "Did i cross the line?",
    ),
    Song(
      title: "There is a light",
      artist: "the smiths",
      album: "assets/cover/thesmiths.jpg",
      audiopath: "mp4/light.mp3",
      quote: "I know you're somewhere, somewhere",
    ),
    Song(
      title: "Cum Through",
      artist: "pakisthani",
      album: "assets/cover/talha.jpeg",
      audiopath: "mp4/talha.mp3",
      quote: "deppressed shauqeen",
    ),
    Song(
      title: "BAAZ",
      artist: "Talha",
      album: "assets/cover/talha.jpg",
      audiopath: "mp4/baaz.mp3",
      quote: "Harne ko raazi ha, is jeetne ki ",
    ),
  ];

  int? _currentSongIndex;

  // Audio player instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Time tracking
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Playing state
  bool _isPlaying = false;

  PlaylistProvider() {
    _listenToDuration();
    _currentSongIndex = 0;
    play();
  }

  // ===== Playback Controls =====

  Future<void> play() async {
    if (_currentSongIndex == null) return;

    final song = _playlists[_currentSongIndex!].audiopath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(song));
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNext() {
    if (_currentSongIndex == null) {
      _currentSongIndex = 0;
    } else if (_currentSongIndex! < _playlists.length - 1) {
      _currentSongIndex = _currentSongIndex! + 1;
    } else {
      _currentSongIndex = 0;
    }
    play();
  }

  void playPrevious() {
    if (_currentDuration.inSeconds > 1) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex == null || _currentSongIndex == 0) {
        _currentSongIndex = _playlists.length - 1;
      } else {
        _currentSongIndex = _currentSongIndex! - 1;
      }
      play();
    }
  }

  // ===== Listeners =====

  void _listenToDuration() {
    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _currentDuration = position;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNext();
    });
  }

  // ===== Getters =====

  List<Song> get playlists => _playlists;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  // ===== Setters =====

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}
