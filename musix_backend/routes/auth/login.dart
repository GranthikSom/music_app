import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/services/auth_service.dart';
import 'package:musix_backend/repositories/data_store.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final email = body['email'] as String?;
  final password = body['password'] as String?;

  if (email == null || password == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Missing email or password'},
    );
  }

  final dataStore = context.read<DataStore>();
  final user = await dataStore.findUserByEmail(email);

  if (user == null ||
      !AuthService.verifyPassword(password, user.passwordHash)) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'error': 'Invalid credentials'},
    );
  }

  final token = AuthService.generateToken(user.id, user.email);

  return Response.json(
    body: {
      'user': user.toPublicJson(),
      'token': token,
    },
  );
}
