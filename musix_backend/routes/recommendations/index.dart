import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';
import 'package:musix_backend/models/song.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final dataStore = context.read<DataStore>();
  final allSongs = dataStore.getAllSongs();

  if (allSongs.isEmpty) {
    return Response.json(
      body: {
        'trending': <Map<String, dynamic>>[],
        'recent': <Map<String, dynamic>>[],
        'recommended': <Map<String, dynamic>>[],
      },
    );
  }

  final trending = List<Song>.from(allSongs)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  final recent = allSongs.take(10).toList();

  final genreList = allSongs
      .where((s) => s.genre != null)
      .map((s) => s.genre)
      .toSet()
      .toList();

  final recommended = <Song>[];
  if (genreList.isNotEmpty) {
    final randomGenre =
        genreList[(DateTime.now().millisecond) % genreList.length];
    recommended.addAll(
      allSongs.where((s) => s.genre == randomGenre).take(5),
    );
  }

  if (recommended.length < 5 && allSongs.length > recommended.length) {
    recommended.addAll(allSongs.take(5 - recommended.length));
  }

  return Response.json(
    body: {
      'trending': trending.take(10).map((s) => s.toJson()).toList(),
      'recent': recent.map((s) => s.toJson()).toList(),
      'recommended': recommended.take(10).map((s) => s.toJson()).toList(),
    },
  );
}
