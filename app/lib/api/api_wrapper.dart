import 'dart:io';

import 'package:co2sensor/models/entry.dart';
import 'package:co2sensor/models/firebase_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'rest/firebase_client.dart';
import 'rest/entries_client.dart';

abstract class ApiWrapper {
  Future<Entry> getLastEntry();

  Future<List<Entry>> getEntriesSince(int timestamp);

  Future<List<Entry>> getAllEntries();

  Future<FirebaseConfig?> getConfig();

  Future sendMessagingKey(String key);

  Future unregisterToken(String key);
}

class RestApiWrapper implements ApiWrapper {
  factory RestApiWrapper(String baseUrl) {
    var apiWrapper = RestApiWrapper._();
    apiWrapper.initialize(baseUrl);
    return apiWrapper;
  }

  RestApiWrapper._();

  late final Dio _dio;
  late EntriesClient _entriesClient;
  late FirebaseClient _firebaseClient;

  initialize(String baseUrl) {
    _dio = Dio();

    _entriesClient = EntriesClient(_dio, baseUrl: baseUrl);
    _firebaseClient = FirebaseClient(_dio, baseUrl: baseUrl);
  }

  @override
  Future<List<Entry>> getAllEntries() {
    return _entriesClient.getAllEntries();
  }

  @override
  Future<FirebaseConfig?> getConfig() {
    if(kIsWeb) {
      return _firebaseClient.getWebFirebaseConfig();
    }
    if(Platform.isAndroid) {
      return _firebaseClient.getAndroidFirebaseConfig();
    } 
    if(Platform.isIOS) {
      return _firebaseClient.getIosFirebaseConfig();
    }
    return Future.value(null);
  }

  @override
  Future<List<Entry>> getEntriesSince(int timestamp) {
    return _entriesClient.getEntriesSince(timestamp);
  }

  @override
  Future<Entry> getLastEntry() {
    return _entriesClient.getLastEntry();
  }

  @override
  Future sendMessagingKey(String key) async {
    await _firebaseClient.registerMessaging(key);
  }

  @override
  Future unregisterToken(String key) async {
    await _firebaseClient.unregisterToken(key);
  }
}
