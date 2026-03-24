import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthService {
  static const String _jwtSecret = 'musix-secret-key-change-in-production';
  static const Duration _tokenExpiry = Duration(days: 7);

  static String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  static bool verifyPassword(String password, String hash) {
    return BCrypt.checkpw(password, hash);
  }

  static String generateToken(String userId, String email) {
    final expiry = DateTime.now().add(_tokenExpiry);
    final jwt = JWT(
      {
        'sub': userId,
        'email': email,
        'exp': expiry.millisecondsSinceEpoch ~/ 1000,
      },
    );
    return jwt.sign(SecretKey(_jwtSecret));
  }

  static Map<String, dynamic>? verifyToken(String token) {
    try {
      final decoded = JWT.verify(token, SecretKey(_jwtSecret));
      return decoded.payload as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
