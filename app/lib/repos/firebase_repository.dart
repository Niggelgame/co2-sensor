import 'package:co2sensor/models/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class AbstractFirebaseRepository {
  Future registerApp(FirebaseConfig config);

  Future unregisterApp();

  Future<String?> getMessagingToken();

  Future<NotificationSettings> askForDeviceNotificationPermission();
}

// const String defaultRemoteFirebaseAppName = "[DEFAULT-REMOTE]";

class FirebaseRepository implements AbstractFirebaseRepository {
  FirebaseApp? _app;

  @override
  Future registerApp(FirebaseConfig config) async {
    final options = FirebaseOptions(
      apiKey: config.apiKey,
      appId: config.appId,
      messagingSenderId: config.messagingSenderId,
      projectId: config.projectId,
    );
    _app = await Firebase.initializeApp(
        options: options, name: defaultFirebaseAppName);

    _app.
  }

  @override
  Future unregisterApp() async {
    if(_app != null) {
      FirebaseMessaging.instance.deleteToken();
    }
  }

  @override
  Future<String?> getMessagingToken() {
    return FirebaseMessaging.instance.getToken();
  }

  @override
  Future<NotificationSettings> askForDeviceNotificationPermission() async {
    // var currentSettings = await FirebaseMessaging.instance.getNotificationSettings();
    // if(currentSettings.authorizationStatus == AuthorizationStatus.notDetermined) {
    // TODO: App-Store Review process: Tell them critical bc in case of problem user wants to be alerted at any time
    return await FirebaseMessaging.instance
        .requestPermission(criticalAlert: true);
    // }
    // return currentSettings;
  }
}
