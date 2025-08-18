import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'local_store_dir.dart';

/// @author Usman Abdulazeez
/// email: abdulazeezusman732@gmail.com
/// Aug, 2025
///

class LocalStorage {
  Future save(String key, dynamic value) async {
    var store = StoreRef.main();

    await store.record(key).put(await _getDatabase(), value);
  }

  Future<dynamic> fetch(String key) async {
    var store = StoreRef.main();

    var result = await store.record(key).get(await _getDatabase());
    return result;
  }

  Future delete(String key) async {
    var store = StoreRef.main();

    await store.record(key).delete(await _getDatabase());
  }

  Future<Database> _getDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = "${appDir.path}/${LocalStorageDir.dbName}";
    DatabaseFactory dbFactory = databaseFactoryIo;

    Database db = await dbFactory.openDatabase(dbPath);
    return db;
  }
}
