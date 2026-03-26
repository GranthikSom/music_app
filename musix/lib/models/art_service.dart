import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ArtworkService {

  static Future<String> saveArtwork(String url) async {

    final directory = await getApplicationDocumentsDirectory();

    final filePath = "${directory.path}/widget_art.png";

    final response = await http.get(Uri.parse(url));

    final file = File(filePath);

    await file.writeAsBytes(response.bodyBytes);

    return filePath;
  }
}