import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      final dataStore = context.read<DataStore>();
      final songs = dataStore.getAllSongs();
      return Response.json(body: songs.map((s) => s.toJson()).toList());

    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
