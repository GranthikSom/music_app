import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final dataStore = context.read<DataStore>();
  final artist = await dataStore.findUserById(id);

  if (artist == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': 'Artist not found'},
    );
  }

  final songs = dataStore.getAllSongs().where((s) => s.userId == id).toList();

  return Response.json(
    body: {
      'artist': artist.toPublicJson(),
      'songs': songs.map((s) => s.toJson()).toList(),
      'song_count': songs.length,
    },
  );
}
