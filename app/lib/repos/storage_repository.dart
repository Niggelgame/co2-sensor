import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageRepository {
  Future initialize();

  bool get initialized;

  Future<bool> store(String key, Map<String, dynamic> data);

  Future remove(String key);

  Future<Map<String, dynamic>?> readJson(String key);

  Future<String?> readString(String key);
}

class SharedPreferencesStorageRepository implements StorageRepository {
  final sharedPreferencesStorageRepositoryLogger = Logger('SharedPreferencesStorageRepository');

  SharedPreferences? _prefs;

  Completer _initializer = Completer();

  @override
  initialize() async {
    _initializer = Completer();
    _prefs = await SharedPreferences.getInstance();
    sharedPreferencesStorageRepositoryLogger.fine('Initialized SharedPreferences');
    _initializer.complete();
  }

  @override
  Future<Map<String, dynamic>?> readJson(String key) async {
    await _initializer.future;
    sharedPreferencesStorageRepositoryLogger.fine('Reading JSON for Key $key');
    var val = await readString(key);
    sharedPreferencesStorageRepositoryLogger.finest('Read value $val for Key $key');
    if(val != null) {
      return jsonDecode(val);
    }
  }

  @override
  Future<String?> readString(String key) async {
    await _initializer.future;
    sharedPreferencesStorageRepositoryLogger.fine('Reading String for Key $key');
    if(_prefs == null) {
      sharedPreferencesStorageRepositoryLogger.warning("There is no Preferences Instance. Please call SharedPreferencesStorageRepository::initialize");
      return null;
    }
    try {
      return _prefs!.getString(key)!;
    } catch (e) {
      sharedPreferencesStorageRepositoryLogger.info("Failed to read String for Key $key", e);
      return null;
    }
    
  }

  @override
  Future<bool> store(String key, Map<String, dynamic> data) async {
    await _initializer.future;
    sharedPreferencesStorageRepositoryLogger.fine('Storing data for Key $key');
    if(_prefs == null) {
      sharedPreferencesStorageRepositoryLogger.warning("There is no Preferences Instance. Please call SharedPreferencesStorageRepository::initialize");
      return false;
    }
    var result = await _prefs!.setString(key, jsonEncode(data));
    sharedPreferencesStorageRepositoryLogger.finest('Storing data for Key $key returned $result');
    return result;
  }

  @override
  bool get initialized => _prefs != null;

  @override
  Future remove(String key) async {
    await _initializer.future;
    if(_prefs != null) {
      _prefs!.remove(key);
      return;
    }
    sharedPreferencesStorageRepositoryLogger.warning("There is no Preferences Instance. Please call SharedPreferencesStorageRepository::initialize");
  }
}
