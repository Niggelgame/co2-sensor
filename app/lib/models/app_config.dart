import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'firebase_config.dart';

part 'app_config.g.dart';

const PREFS_APP_CONFIG_KEY = "APP_CONFIG_KEY";

@JsonSerializable()
class AppConfig extends Equatable {
  final String? connectionUrl;
  final FirebaseConfig? firebaseConfig;

  const AppConfig(this.connectionUrl, this.firebaseConfig);

  @override
  List<Object?> get props => [connectionUrl, firebaseConfig];

  @override
  bool? get stringify => true;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);

  factory AppConfig.empty() {
    return AppConfig(null, null);
  }

  AppConfig copyWith(
      {String? connectionUrl,
      FirebaseConfig? firebaseConfig,
      bool allowOverwriteFirebaseConfigNull = false}) {
    return AppConfig(
        connectionUrl ?? this.connectionUrl,
        allowOverwriteFirebaseConfigNull
            ? firebaseConfig
            : firebaseConfig ?? this.firebaseConfig);
  }
}
