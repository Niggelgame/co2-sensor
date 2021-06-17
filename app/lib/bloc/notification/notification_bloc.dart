import 'package:co2sensor/api/api_wrapper.dart';
import 'package:co2sensor/models/firebase_config.dart';
import 'package:co2sensor/repos/firebase_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

part 'notification_state.dart';
part 'notification_event.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(UninitializedNotificationState());

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if(event is LoadNotificationEvent) {
      yield LoadingNotificationState();
      if(event.config == null) {
        yield NoConfigExistingState();
      } else {
        var firebaseRepo = GetIt.I.get<AbstractFirebaseRepository>();
        await firebaseRepo.registerApp(event.config!);

        var settings = await firebaseRepo.askForDeviceNotificationPermission();

        var newState = _mapSettingToState(settings);

        if(GetIt.I.isRegistered<ApiWrapper>()) {
          var apiWrapper = GetIt.I.get<ApiWrapper>();
          var newToken = await firebaseRepo.getMessagingToken();

          if(newToken != null) {
            try {
              apiWrapper.sendMessagingKey(newToken);
              yield newState;
            } catch (e) {
              yield ErrorNotificationState();
            }
          } else {
            yield ErrorNotificationState();
          }
        }
      }
    }
  }

  NotificationState _mapSettingToState(NotificationSettings setting) {
    switch(setting.authorizationStatus) {
      case AuthorizationStatus.authorized:
      case AuthorizationStatus.provisional: return RunningNotificationState();
      case AuthorizationStatus.notDetermined: return UninitializedNotificationState();
      case AuthorizationStatus.denied: return UnavailableNotificationState();
    }
  }
}