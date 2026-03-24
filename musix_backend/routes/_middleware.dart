import 'package:dart_frog/dart_frog.dart';
import 'package:musix_backend/repositories/data_store.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final dataStore = DataStore();
    await dataStore.init();
    return handler(context.provide<DataStore>(() => dataStore));
  };
}
