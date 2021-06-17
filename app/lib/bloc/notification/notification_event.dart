part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotificationEvent extends NotificationEvent {
  final FirebaseConfig? config;

  LoadNotificationEvent(this.config);

  @override
  List<Object?> get props => [config];
}
