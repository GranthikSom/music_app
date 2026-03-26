import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';

Future<Response> onRequest(RequestContext context) async {
  final dataStore = context.read<DataStore>();
  final songs = dataStore.getAllSongs();
  return Response.json(
    body: {
      'songsCount': songs.length,
      'songs': songs.map((s) => s.toJson()).toList(),
      'songIds': songs.map((s) => s.id).toList(),
    },
  );
}
