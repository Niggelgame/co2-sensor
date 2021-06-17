part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeEvent extends AppEvent {}

class SetConfigEvent extends AppEvent {
  final AppConfig config;

  SetConfigEvent(this.config);

  @override
  List<Object?> get props => [config];
}

class LogoutEvent extends AppEvent {}