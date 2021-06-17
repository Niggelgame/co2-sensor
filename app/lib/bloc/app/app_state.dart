part of 'app_bloc.dart';

class AppState extends Equatable {
  final bool loading;
  final AppConfig config;

  AppState(this.loading, this.config);

  @override
  List<Object?> get props => [loading, config];

  AppState copyWith({bool? loading, AppConfig? config}) {
    return AppState(loading ?? this.loading, config ?? this.config);
  }
}
