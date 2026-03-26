import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
};

Handler middleware(Handler handler) {
  return (context) async {
    if (context.request.method == HttpMethod.options) {
      return Response(headers: _corsHeaders);
    }

    final dataStore = DataStore();
    await dataStore.init();
    final response = await handler(context.provide<DataStore>(() => dataStore));
    return response.copyWith(headers: {..._corsHeaders, ...response.headers});
  };
}
