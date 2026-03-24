import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/models/user.dart';
import 'package:musix_backend/services/storage_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final user = context.read<User>();

  try {
    final formData = await context.request.formData();
    final file = formData.files['file'];

    if (file == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'No file provided'},
      );
    }

    final name = file.name;
    final data = await file.readAsBytes();
    final path = await StorageService.saveCoverImage(user.id, name, data);

    return Response.json(body: {'url': '/uploads/covers/$path'});
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': e.toString()},
    );
  }
}
