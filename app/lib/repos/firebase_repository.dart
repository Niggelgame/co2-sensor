import 'package:co2sensor/models/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_apns/apns.dart';

abstract class AbstractNotificationRepository {
  Future registerApp(FirebaseConfig config);

  Future unregisterApp();

  Future<String?> getMessagingToken();

  Future<NotificationSettings> askForDeviceNotificationPermission();
}

const String defaultRemoteFirebaseAppName = "[DEFAULT-REMOTE]";

class FirebaseRepository implements AbstractNotificationRepository {
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
        options: options, name: defaultRemoteFirebaseAppName);
  }

  @override
  Future unregisterApp() async {
    if (_app != null) {
      FirebaseMessaging.instanceFor(app: _app!)!.deleteToken();
    }
  }

  @override
  Future<String?> getMessagingToken() {
    // assert(_app != null, );
    if (_app != null) {
      return FirebaseMessaging.instanceFor(app: _app!)!.getToken();
    }
    return Future.value(null);
  }

  @override
  Future<NotificationSettings> askForDeviceNotificationPermission() async {
    // var currentSettings = await FirebaseMessaging.instance.getNotificationSettings();
    // if(currentSettings.authorizationStatus == AuthorizationStatus.notDetermined) {
    // TODO: App-Store Review process: Tell them critical bc in case of problem user wants to be alerted at any time
    return await FirebaseMessaging.instanceFor(app: _app!)!
        .requestPermission(criticalAlert: true);
    // }
    // return currentSettings;
  }
}

class ApnsNotificationRepository implements AbstractNotificationRepository {
  PushConnector? _connector;

  @override
  Future<NotificationSettings> askForDeviceNotificationPermission() async {
    if (_connector != null) {
      _connector!.requestNotificationPermissions();
      if (_connector!.isDisabledByUser.value) {
        return NotificationSettings(
          alert: AppleNotificationSetting.disabled,
          announcement: AppleNotificationSetting.notSupported,
          authorizationStatus: AuthorizationStatus.denied,
          badge: AppleNotificationSetting.notSupported,
          carPlay: AppleNotificationSetting.notSupported,
          lockScreen: AppleNotificationSetting.notSupported,
          notificationCenter: AppleNotificationSetting.notSupported,
          showPreviews: AppleShowPreviewSetting.notSupported,
          sound: AppleNotificationSetting.notSupported
        );
      }
      return NotificationSettings(
          alert: AppleNotificationSetting.disabled,
          announcement: AppleNotificationSetting.notSupported,
          authorizationStatus: AuthorizationStatus.authorized,
          badge: AppleNotificationSetting.notSupported,
          carPlay: AppleNotificationSetting.notSupported,
          lockScreen: AppleNotificationSetting.notSupported,
          notificationCenter: AppleNotificationSetting.notSupported,
          showPreviews: AppleShowPreviewSetting.notSupported,
          sound: AppleNotificationSetting.notSupported
        );
    } else {
      return NotificationSettings(
          alert: AppleNotificationSetting.disabled,
          announcement: AppleNotificationSetting.notSupported,
          authorizationStatus: AuthorizationStatus.notDetermined,
          badge: AppleNotificationSetting.notSupported,
          carPlay: AppleNotificationSetting.notSupported,
          lockScreen: AppleNotificationSetting.notSupported,
          notificationCenter: AppleNotificationSetting.notSupported,
          showPreviews: AppleShowPreviewSetting.notSupported,
          sound: AppleNotificationSetting.notSupported
        );
    }
  }

  @override
  Future<String?> getMessagingToken() async {
    if (_connector == null) {
      return null;
    }
    return _connector!.token.value;
  }

  @override
  Future registerApp(FirebaseConfig config) async {
    _connector = createPushConnector();
  }

  @override
  Future unregisterApp() async {
    if (_connector != null) {
      _connector!.unregister();
    }
  }
}
