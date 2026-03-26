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

  final userId = payload['sub'] as String;
  final type = context.request.uri.queryParameters['type'] ?? 'following';

  final dataStore = context.read<DataStore>();

  List<Map<String, dynamic>> users;
  if (type == 'followers') {
    final followers = dataStore.getFollowers(userId);
    users = followers.map((f) {
      final user = dataStore.getAllUsers().firstWhere(
        (u) => u.id == f.followerId,
        orElse: () => throw Exception('User not found'),
      );
      return {
        ...user.toPublicJson(),
        'is_following': true,
      };
    }).toList();
  } else {
    final following = dataStore.getFollowing(userId);
    users = following.map((f) {
      final user = dataStore.getAllUsers().firstWhere(
        (u) => u.id == f.followingId,
        orElse: () => throw Exception('User not found'),
      );
      return {
        ...user.toPublicJson(),
        'is_following': true,
      };
    }).toList();
  }

  return Response.json(body: users);
}
