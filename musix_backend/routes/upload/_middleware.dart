import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:musix_backend/models/user.dart';
import 'package:musix_backend/services/auth_service.dart';
import 'package:musix_backend/repositories/data_store.dart';

Handler middleware(Handler handler) {
  return handler.use(
    bearerAuthentication<User>(
      authenticator: (context, token) async {
        final payload = AuthService.verifyToken(token);
        if (payload == null) return null;

        final userId = payload['sub'] as String?;
        if (userId == null) return null;

        final dataStore = context.read<DataStore>();
        return await dataStore.findUserById(userId);
      },
    ),
  );
}
