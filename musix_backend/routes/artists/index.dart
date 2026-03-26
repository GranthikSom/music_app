import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final dataStore = context.read<DataStore>();
  final artists = dataStore.getArtists();

  final artistsWithCounts = artists.map((artist) {
    final songCount = dataStore
        .getAllSongs()
        .where((s) => s.userId == artist.id)
        .length;
    return {
      ...artist.toPublicJson(),
      'song_count': songCount,
    };
  }).toList();

  return Response.json(body: artistsWithCounts);
}
