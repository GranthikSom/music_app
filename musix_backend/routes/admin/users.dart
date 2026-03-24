import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';
import 'package:musix_backend/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
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
  final admin = await dataStore.findUserById(payload['sub'] as String);

  if (admin == null || admin.role.name != 'admin') {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {'error': 'Admin access required'},
    );
  }

  if (context.request.method == HttpMethod.get) {
    final users = dataStore.getAllUsers();
    return Response.json(
      body: users.map((u) => u.toPublicJson()).toList(),
    );
  }

  return Response(statusCode: HttpStatus.methodNotAllowed);
}
