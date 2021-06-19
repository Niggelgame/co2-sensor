import 'package:co2sensor/api/api_wrapper.dart';
import 'package:co2sensor/bloc/notification/notification_bloc.dart';
import 'package:co2sensor/models/app_config.dart';
import 'package:co2sensor/models/firebase_config.dart';
import 'package:co2sensor/repos/firebase_repository.dart';
import 'package:co2sensor/repos/storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._notificationBloc) : super(AppState(true, AppConfig.empty()));

  NotificationBloc _notificationBloc;

  final appBlocLogger = Logger('AppBloc');

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is InitializeEvent) {
      yield this.state.copyWith(loading: true);
      yield await _mapInitializeEvent(event);
    } else if (event is SetConfigEvent) {
      yield this.state.copyWith(loading: true);
      yield await _mapSetConfigEvent(event);
    } else if (event is LogoutEvent) {
      yield this.state.copyWith(loading: true);
      yield await _mapLogoutEvent(event);
    }
  }

  Future<AppState> _mapInitializeEvent(InitializeEvent event) async {
    final storageRepo = GetIt.I.get<StorageRepository>();
    final configJson = await storageRepo.readJson(PREFS_APP_CONFIG_KEY);
    if (configJson == null) {
      return AppState(false, AppConfig.empty());
    } else {
      var config = AppConfig.fromJson(configJson);
      if (config != AppConfig.empty() && config.connectionUrl != null) {
        if (GetIt.I.isRegistered<ApiWrapper>()) {
          GetIt.I.unregister<ApiWrapper>();
        }

        GetIt.I.registerSingleton<ApiWrapper>(
            RestApiWrapper(config.connectionUrl!));
      }
      return AppState(false, config);
    }
  }

  Future<AppState> _mapSetConfigEvent(SetConfigEvent event) async {
    final storageRepo = GetIt.I.get<StorageRepository>();
    await storageRepo.store(PREFS_APP_CONFIG_KEY, event.config.toJson());
    AppConfig newConfig = event.config;
    if (event.config != AppConfig.empty() &&
        event.config.connectionUrl != null) {
      if (GetIt.I.isRegistered<ApiWrapper>()) {
        GetIt.I.unregister<ApiWrapper>();
      }

      GetIt.I.registerSingleton<ApiWrapper>(
          RestApiWrapper(event.config.connectionUrl!));

      // Only reload Firebase Configuration if connection changes
      if (state.config.connectionUrl != event.config.connectionUrl) {
        // Load new Firebase Config and Alert Notification Bloc
        var api = GetIt.I.get<ApiWrapper>();
        FirebaseConfig? fbConfig;
        try {
          fbConfig = await api.getConfig();
          newConfig = event.config.copyWith(
              firebaseConfig: fbConfig, allowOverwriteFirebaseConfigNull: true);
        } catch (e) {
          appBlocLogger.fine("Failed to load config: $e");
          fbConfig = null;
        }

        _notificationBloc.add(LoadNotificationEvent(fbConfig));
      }
    }
    return AppState(false, newConfig);
  }

  Future<AppState> _mapLogoutEvent(LogoutEvent event) async {
    final firebaseRepo = GetIt.I.get<AbstractFirebaseRepository>();
    final storageRepo = GetIt.I.get<StorageRepository>();

    storageRepo.remove(PREFS_APP_CONFIG_KEY);
    final oldToken = await firebaseRepo.getMessagingToken();
    firebaseRepo.unregisterApp();
    if (oldToken != null) {
      try {
        GetIt.I.get<ApiWrapper>().unregisterToken(oldToken);
      } catch (e) {
        appBlocLogger.warning('deregistration of token failed');
      }
    }

    return AppState(false, AppConfig.empty());
  }
}
