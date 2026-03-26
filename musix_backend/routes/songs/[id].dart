import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/models/user.dart';
import 'package:musix_backend/repositories/data_store.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final dataStore = context.read<DataStore>();
  final song = dataStore.getSongById(id);

  if (song == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': 'Song not found'},
    );
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return Response.json(body: song.toJson());

    case HttpMethod.delete:
      final user = context.read<User>();
      if (song.userId != user.id) {
        return Response.json(
          statusCode: HttpStatus.forbidden,
          body: {'error': 'Not authorized to delete this song'},
        );
      }
      await dataStore.deleteSong(id);
      return Response.json(body: {'message': 'Song deleted'});

    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
