part of 'notification_bloc.dart';

// Permission for Notifactions denied
class UnavailableNotification implements Exception {}

// No config available from server
class NoConfigExisting implements Exception {
}

class ErrorNotification implements Exception {}