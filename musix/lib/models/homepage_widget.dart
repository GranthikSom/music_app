import 'package:flutter/services.dart';

class WidgetService {
  static const MethodChannel _channel = MethodChannel("music_widget");

  static Future<void> updateWidget({
    required String title,
    required String artist,
    required String art,
  }) async {
    try {
      await _channel.invokeMethod("updateWidget", {
        "title": title,
        "artist": artist,
        "art": art,
      });
    } catch (e) {
      print("Widget update error: $e");
    }
  }
}
