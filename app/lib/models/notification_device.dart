import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_device.g.dart';

@JsonSerializable()
class NotificationDevice extends Equatable {
  final String key;
  
  const NotificationDevice(this.key);
  
  factory NotificationDevice.fromJson(Map<String, dynamic> json) => _$NotificationDeviceFromJson(json);
  
  Map<String, dynamic> toJson() => _$NotificationDeviceToJson(this);
  
  @override
  List<Object?> get props => [key];
  
  @override
  bool get stringify => true;
}