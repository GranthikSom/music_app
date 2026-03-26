import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';
import 'package:musix_backend/services/auth_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.delete) {
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
  final admin = await dataStore.findUserById(payload['sub'] as String);

  if (admin == null || admin.role.name != 'admin') {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {'error': 'Admin access required'},
    );
  }

  final user = await dataStore.findUserById(id);
  if (user == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': 'User not found'},
    );
  }

  if (user.role.name == 'admin') {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {'error': 'Cannot delete another admin'},
    );
  }

  await dataStore.deleteUser(id);

  return Response.json(body: {'message': 'User deleted successfully'});
}
