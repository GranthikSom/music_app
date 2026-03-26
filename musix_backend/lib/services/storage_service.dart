import 'dart:io';

class StorageService {
  static const String _uploadsPath = 'public/uploads';
  static const int maxAudioSize = 50 * 1024 * 1024; // 50MB
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB

  static const List<String> allowedAudioTypes = [
    'audio/mpeg',
    'audio/mp3',
    'audio/wav',
    'audio/x-wav',
    'audio/m4a',
    'audio/aac',
    'audio/ogg',
  ];

  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp',
  ];

  static Future<String> saveAudioFile(
    String userId,
    String filename,
    List<int> bytes,
  ) async {
    if (bytes.length > maxAudioSize) {
      throw StorageException(
        'File too large. Maximum size is ${maxAudioSize ~/ (1024 * 1024)}MB',
      );
    }

    final userDir = Directory('$_uploadsPath/audio/$userId');
    await userDir.create(recursive: true);

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = filename.split('.').last;
    final savedFilename = '$timestamp.$extension';
    final file = File('${userDir.path}/$savedFilename');
    await file.writeAsBytes(bytes);

    return '$userId/$savedFilename';
  }

  static Future<String> saveCoverImage(
    String userId,
    String filename,
    List<int> bytes,
  ) async {
    if (bytes.length > maxImageSize) {
      throw StorageException(
        'File too large. Maximum size is ${maxImageSize ~/ (1024 * 1024)}MB',
      );
    }

    final userDir = Directory('$_uploadsPath/covers/$userId');
    await userDir.create(recursive: true);

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = filename.split('.').last;
    final savedFilename = '$timestamp.$extension';
    final file = File('${userDir.path}/$savedFilename');
    await file.writeAsBytes(bytes);

    return '$userId/$savedFilename';
  }

  static Future<void> deleteFile(String type, String path) async {
    final file = File('$_uploadsPath/$type/$path');
    if (await file.exists()) {
      await file.delete();
    }
  }

  static String getAudioPath(String path) => '$_uploadsPath/audio/$path';
  static String getCoverPath(String path) => '$_uploadsPath/covers/$path';
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => message;
}
