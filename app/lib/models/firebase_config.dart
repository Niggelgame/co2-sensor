import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firebase_config.g.dart';

@JsonSerializable()
class FirebaseConfig extends Equatable {
  @JsonKey(name: 'api_key')
  final String apiKey;
  @JsonKey(name: 'app_id')
  final String appId;
  @JsonKey(name: 'messaging_sender_id')
  final String messagingSenderId;
  @JsonKey(name: 'project_id')
  final String projectId;

  const FirebaseConfig(
      this.apiKey, this.appId, this.messagingSenderId, this.projectId);

  @override
  List<Object?> get props => [apiKey, appId, messagingSenderId, projectId];

  factory FirebaseConfig.fromJson(Map<String, dynamic> json) =>
      _$FirebaseConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseConfigToJson(this);
}
