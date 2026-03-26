import 'package:flutter_application_1/models/art_service.dart';
import 'package:flutter_application_1/models/homepage_widget.dart';

class PlayerService {
  static Future<void> onSongChanged({
    required String title,
    required String artist,
    required String artworkUrl,
  }) async {
    final artPath = await ArtworkService.saveArtwork(artworkUrl);

    await WidgetService.updateWidget(
      title: title,
      artist: artist,
      art: artPath,
    );
  }
}
