import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';
import 'package:musix_backend/models/song.dart';
import 'package:musix_backend/repositories/data_store.dart';
import 'package:musix_backend/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final authHeader = context.request.headers['authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'error': 'Missing or invalid authorization header'},
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

  final userId = payload['sub'] as String?;
  if (userId == null) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'error': 'Invalid token payload'},
    );
  }

  final dataStore = context.read<DataStore>();
  final user = await dataStore.findUserById(userId);
  if (user == null) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'error': 'User not found'},
    );
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final title = body['title'] as String?;
  final artist = body['artist'] as String?;
  final audioUrl = body['audio_url'] as String?;
  final coverUrl = body['cover_url'] as String?;
  final durationSeconds = body['duration_seconds'] as int?;
  final genre = body['genre'] as String?;

  if (title == null || artist == null || audioUrl == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Missing required fields'},
    );
  }

  final now = DateTime.now();
  final song = Song(
    id: const Uuid().v4(),
    title: title,
    artist: artist,
    audioUrl: audioUrl,
    coverUrl: coverUrl,
    durationSeconds: durationSeconds,
    genre: genre,
    userId: user.id,
    createdAt: now,
  );

  await dataStore.createSong(song);

  return Response.json(
    statusCode: HttpStatus.created,
    body: song.toJson(),
  );
}
