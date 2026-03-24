import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final uri = context.request.uri;
  final query = uri.queryParameters['q'] ?? '';
  final genre = uri.queryParameters['genre'];
  final sortBy = uri.queryParameters['sort'] ?? 'date';
  final order = uri.queryParameters['order'] ?? 'desc';
  final descending = order.toLowerCase() != 'asc';
  final fromStr = uri.queryParameters['from'];
  final toStr = uri.queryParameters['to'];

  DateTime? fromDate;
  DateTime? toDate;
  if (fromStr != null) {
    fromDate = DateTime.tryParse(fromStr);
  }
  if (toStr != null) {
    toDate = DateTime.tryParse(toStr);
  }

  final dataStore = context.read<DataStore>();
  final songs = dataStore.searchSongs(
    query,
    genre: genre,
    sortBy: sortBy,
    descending: descending,
    fromDate: fromDate,
    toDate: toDate,
  );

  return Response.json(body: songs.map((s) => s.toJson()).toList());
}
