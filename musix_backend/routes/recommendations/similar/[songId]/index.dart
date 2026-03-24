import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';

Future<Response> onRequest(RequestContext context, String songId) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final dataStore = context.read<DataStore>();
  final song = dataStore.getSongById(songId);

  if (song == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': 'Song not found'},
    );
  }

  final allSongs = dataStore.getAllSongs();
  final similar = allSongs
      .where((s) {
        if (s.id == songId) return false;
        if (song.genre != null && s.genre == song.genre) return true;
        if (s.artist.toLowerCase() == song.artist.toLowerCase()) return true;
        return false;
      })
      .take(10)
      .toList();

  return Response.json(body: similar.map((s) => s.toJson()).toList());
}
