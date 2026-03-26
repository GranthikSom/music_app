import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';
import 'package:musix_backend/models/user.dart';
import 'package:musix_backend/services/auth_service.dart';
import 'package:musix_backend/repositories/data_store.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final email = body['email'] as String?;
  final password = body['password'] as String?;
  final username = body['username'] as String?;

  if (email == null || password == null || username == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Missing required fields'},
    );
  }

  final dataStore = context.read<DataStore>();
  final existing = await dataStore.findUserByEmail(email);
  if (existing != null) {
    return Response.json(
      statusCode: HttpStatus.conflict,
      body: {'error': 'Email already registered'},
    );
  }

  final now = DateTime.now();
  final user = User(
    id: const Uuid().v4(),
    email: email,
    passwordHash: AuthService.hashPassword(password),
    username: username,
    createdAt: now,
    updatedAt: now,
  );

  await dataStore.createUser(user);
  final token = AuthService.generateToken(user.id, user.email);

  return Response.json(
    statusCode: HttpStatus.created,
    body: {
      'user': user.toPublicJson(),
      'token': token,
    },
  );
}
