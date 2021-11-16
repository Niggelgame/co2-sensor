import 'package:co2sensor/api/api_wrapper.dart';
import 'package:co2sensor/models/app_config.dart';
import 'package:co2sensor/models/firebase_config.dart';
import 'package:co2sensor/repos/notification_repository.dart';
import 'package:co2sensor/repos/storage_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:riverpod/riverpod.dart';

part 'app_state.dart';

final appProvider = StateNotifierProvider<AppProvider, AppState>((ref) {
  final app = AppProvider(ref.read)..initialize();
  return app;
});

final connectionUrlProvider =
    Provider<String?>((ref) => ref.watch(appProvider).config.connectionUrl);

final _firebaseConfigLogger = Logger('FirebaseConfig');

final firebaseConfigProvider = FutureProvider<FirebaseConfig?>((ref) async {
  final api = ref.watch(apiProvider);
  if (api == null) {
    return null;
  }
  try {
    final config = await api.getConfig();
    _firebaseConfigLogger.finer('Loaded Firebase config: $config');
    return config;
  } on DioError catch (e) {
    _firebaseConfigLogger.warning("Could not receive App-Config: ${e.message}");
  } catch (e) {
    _firebaseConfigLogger.warning("Could not receive App-Config");
    rethrow;
  }
}, dependencies: [connectionUrlProvider, apiProvider]);

class AppProvider extends StateNotifier<AppState> {
  Reader _read;
  AppProvider(this._read) : super(AppState(true, AppConfig.empty()));

  final appStateLogger = Logger('AppBloc');

  Future<void> initialize() async {
    appStateLogger.shout("Initializing App");
    final storageRepo = _read(storageRepositoryProvider);
    final configJson = await storageRepo.readJson(PREFS_APP_CONFIG_KEY);
    appStateLogger.shout("Loaded AppConfig");
    if (configJson == null) {
      state = AppState(false, AppConfig.empty());
    } else {
      final config = AppConfig.fromJson(configJson);
      state = AppState(false, config);
    }
  }

  Future<void> setConfig(AppConfig config) async {
    final storageRepo = _read(storageRepositoryProvider);
    storageRepo.store(PREFS_APP_CONFIG_KEY, config.toJson());
    state = AppState(false, config);
  }

  Future<void> logout() async {
    final storageRepo = _read(storageRepositoryProvider);
    final notificationsRepo = _read(notificationRepositoryProvider);
    // Revoke Notification Token Access
    final oldToken = await notificationsRepo.getMessagingToken();
    notificationsRepo.unregisterApp();
    // Remove config store
    storageRepo.remove(PREFS_APP_CONFIG_KEY);
    // Unregister token at backend. Not necessary, but will remove unnecessary call to FB Messaging services
    final api = _read(apiProvider);
    if (api != null && oldToken != null) {
      try {
        api.unregisterToken(oldToken);
      } catch (e) {
        appStateLogger.info("Failed to deregister token");
      }
    }

    state = AppState(false, AppConfig.empty());
  }
}
