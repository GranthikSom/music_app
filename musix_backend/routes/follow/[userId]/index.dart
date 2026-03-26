import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';
import 'package:musix_backend/services/auth_service.dart';

Future<Response> onRequest(RequestContext context, String userId) async {
  if (context.request.method != HttpMethod.post) {
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

  final followerId = payload['sub'] as String;

  if (followerId == userId) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Cannot follow yourself'},
    );
  }

  final dataStore = context.read<DataStore>();
  final targetUser = await dataStore.findUserById(userId);
  if (targetUser == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': 'User not found'},
    );
  }

  final wasFollowing = dataStore.isFollowing(followerId, userId);
  await dataStore.toggleFollow(followerId, userId);

  return Response.json(
    body: {
      'is_following': !wasFollowing,
      'follower_count': dataStore.getFollowerCount(userId),
    },
  );
}
