import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'firebase_config.dart';

part 'app_config.g.dart';

const PREFS_APP_CONFIG_KEY = "APP_CONFIG_KEY";

@JsonSerializable()
class AppConfig extends Equatable {
  final String? connectionUrl;

  const AppConfig(this.connectionUrl);

  @override
  List<Object?> get props => [connectionUrl];

  @override
  bool? get stringify => true;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);

  factory AppConfig.empty() {
    return AppConfig(null);
  }

  AppConfig copyWith({
    String? connectionUrl,
  }) {
    return AppConfig(
      connectionUrl ?? this.connectionUrl,
    );
  }
}
