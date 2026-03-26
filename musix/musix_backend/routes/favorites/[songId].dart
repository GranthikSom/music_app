import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/models/user.dart';
import 'package:musix_backend/repositories/data_store.dart';

Future<Response> onRequest(RequestContext context, String songId) async {
  final dataStore = context.read<DataStore>();
  final user = context.read<User>();

  if (context.request.method == HttpMethod.post) {
    await dataStore.toggleFavorite(user.id, songId);
    final isFavorite = dataStore.isFavorite(user.id, songId);
    return Response.json(body: {'is_favorite': isFavorite});
  }

  return Response(statusCode: HttpStatus.methodNotAllowed);
}
