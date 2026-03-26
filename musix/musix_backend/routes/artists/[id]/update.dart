import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';
import 'package:musix_backend/services/auth_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.put) {
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

  final userId = payload['sub'] as String?;
  if (userId == null || userId != id) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {'error': 'Can only update your own profile'},
    );
  }

  final dataStore = context.read<DataStore>();
  final user = await dataStore.findUserById(id);

  if (user == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': 'User not found'},
    );
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username'] as String?;
  final bio = body['bio'] as String?;
  final avatarUrl = body['avatar_url'] as String?;

  final updated = user.copyWith(
    username: username ?? user.username,
    bio: bio ?? user.bio,
    avatarUrl: avatarUrl ?? user.avatarUrl,
    updatedAt: DateTime.now(),
  );

  await dataStore.updateUser(updated);

  return Response.json(body: updated.toPublicJson());
}
