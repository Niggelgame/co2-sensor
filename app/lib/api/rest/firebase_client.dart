

import 'package:co2sensor/models/firebase_config.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'firebase_client.g.dart';

@RestApi()
abstract class FirebaseClient {
  factory FirebaseClient(Dio dio, {String baseUrl}) = _FirebaseClient;

  @GET("/messaging/config/android")
  Future<FirebaseConfig?> getAndroidFirebaseConfig();

  @GET("/messaging/config/ios")
  Future<FirebaseConfig?> getIosFirebaseConfig();

  @GET("/messaging/config/web")
  Future<FirebaseConfig?> getWebFirebaseConfig();

  @POST("/messaging/register")
  Future registerMessaging(@Body() String key);

  @POST("/messaging/unregister")
  Future unregisterToken(@Body() String key);
}