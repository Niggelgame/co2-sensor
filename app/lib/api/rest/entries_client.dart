

import 'package:co2sensor/models/entry.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'entries_client.g.dart';

@RestApi()
abstract class EntriesClient {
  factory EntriesClient(Dio dio, {String baseUrl}) = _EntriesClient;

  @GET("/last")
  Future<Entry> getLastEntry();

  @GET("/since/{timestamp}")
  Future<List<Entry>> getEntriesSince(@Path() int timestamp);

  @GET("/all")
  Future<List<Entry>> getAllEntries();
}