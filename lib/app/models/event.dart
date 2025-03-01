import 'package:drill_events/app/models/organization.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
final class EventModel extends Equatable {
  const EventModel({
    required this.eventId,
    required this.title,
    required this.description,
    required this.organization,
    required this.startDate,
    required this.startTime,
    required this.endTime,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);

  @JsonKey(name: 'id')
  final String eventId;
  final String title, description;
  @JsonKey(name: 'org')
  final OrganizationModel organization;
  final String startDate, startTime;
  final String? endTime;

  @override
  List<Object?> get props => [eventId, title, description, organization, startDate, startTime, endTime];

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
