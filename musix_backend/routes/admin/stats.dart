import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';
import 'package:musix_backend/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'error': 'Missing authorization'},
    );
  }

  final token = authHeader.substring(7);
  final payload = AuthService.verifyToken(token);
  if (payload == null) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'error': 'Invalid token'},
    );
  }

  final dataStore = context.read<DataStore>();
  final user = await dataStore.findUserById(payload['sub'] as String);

  if (user == null || user.role.name != 'admin') {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {'error': 'Admin access required'},
    );
  }

  final users = dataStore.getAllUsers();
  final songs = dataStore.getAllSongs();
  final playlists = dataStore.getAllPlaylists();

  final artistCount = users.where((u) => u.role.name == 'artist').length;
  final userCount = users.where((u) => u.role.name == 'user').length;

  return Response.json(
    body: {
      'total_users': users.length,
      'total_artists': artistCount,
      'total_regular_users': userCount,
      'total_songs': songs.length,
      'total_playlists': playlists.length,
      'recent_users': users.take(5).map((u) => u.toPublicJson()).toList(),
      'recent_songs': songs.take(5).map((s) => s.toJson()).toList(),
    },
  );
}
