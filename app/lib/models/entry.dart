import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry.g.dart';

@JsonSerializable()
class Entry extends Equatable {
  final int value;
  final int timestamp;

  const Entry(this.value, this.timestamp);

  @override
  List<Object?> get props => [value, timestamp];

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  Map<String, dynamic> toJson() => _$EntryToJson(this);
}
