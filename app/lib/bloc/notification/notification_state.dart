part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UninitializedNotificationState extends NotificationState {}

// Permission for Notifactions denied
class UnavailableNotificationState extends NotificationState {}

class LoadingNotificationState extends NotificationState {}

// Notifactions enabled and running
class RunningNotificationState extends NotificationState {}

// No config available from server
class NoConfigExistingState extends NotificationState {}

class ErrorNotificationState extends NotificationState {}