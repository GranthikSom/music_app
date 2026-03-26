import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/models/user.dart';
import 'package:musix_backend/repositories/data_store.dart';

Future<Response> onRequest(RequestContext context) async {
  final dataStore = context.read<DataStore>();
  final user = context.read<User>();

  switch (context.request.method) {
    case HttpMethod.get:
      final favorites = dataStore.getUserFavorites(user.id);
      final songs = favorites
          .map((f) => dataStore.getSongById(f.songId))
          .where((s) => s != null)
          .map((s) => s!.toJson())
          .toList();
      return Response.json(body: songs);

    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
