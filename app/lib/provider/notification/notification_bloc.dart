import 'package:co2sensor/api/api_wrapper.dart';
import 'package:co2sensor/provider/app/app_provider.dart';
import 'package:co2sensor/repos/notification_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';
import 'package:riverpod/riverpod.dart';

part 'notification_exceptions.dart';

final _notificationStateLogger = Logger("NotificationState");

final notificationStateProvider = FutureProvider((ref) async {
  final fbConfig = await ref.watch(firebaseConfigProvider.future);
  if (fbConfig == null) {
    _notificationStateLogger
        .warning("No Firebase Config available to initialize with (yet).");
    throw NoConfigExisting();
  }
  final notificationRepo = ref.watch(notificationRepositoryProvider);

  await notificationRepo.registerApp(fbConfig);
  final notificationSettings =
      await notificationRepo.askForDeviceNotificationPermission();

  switch (notificationSettings.authorizationStatus) {
    case AuthorizationStatus.authorized:
    case AuthorizationStatus.provisional:
      _notificationStateLogger
          .info('Notification permission granted. Registering at server.');
      // Register Notification Token
      final api = ref.watch(apiProvider);
      if (api == null) {
        _notificationStateLogger.warning(
            "Could not register Notification Token with no API. Could be fixed by restarting the app");
        return false;
      }
      final token = await notificationRepo.getMessagingToken();
      if (token == null) {
        _notificationStateLogger.warning(
            "Could not get Token for allowed notifications. Could be fixed by restarting the app");
        return false;
      }
      try {
        api.sendMessagingKey(token);
      } catch (e) {
        _notificationStateLogger.warning(
            "Could not register Notification Token with API. Could be fixed by restarting the app");
        return false;
      }
      _notificationStateLogger.info('Notification Token registered.');
      return true;
    case AuthorizationStatus.notDetermined:
      return false;
    case AuthorizationStatus.denied:
      return UnavailableNotification();
  }
});
