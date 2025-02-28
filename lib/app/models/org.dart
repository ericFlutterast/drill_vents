import 'package:drill_events/app/models/event.dart';
import 'package:drill_events/app/models/spot.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'org.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
final class OrgModel extends Equatable {
  const OrgModel({
    required this.id,
    required this.title,
    required this.description,
    this.events = const [],
    this.spots = const [],
  });

  factory OrgModel.fromJson(Map<String, dynamic> json) => _$OrgModelFromJson(json);

  final String id, title, description;
  final List<EventModel> events;
  final List<SpotModel> spots;

  OrgModel copyWith({List<EventModel>? events, List<SpotModel>? spots}) => OrgModel(
    id: id,
    title: title,
    description: description,
    events: events ?? this.events,
    spots: spots ?? this.spots,
  );

  @override
  List<Object?> get props => [id, title, description, events, spots];

  Map<String, dynamic> toJson() => _$OrgModelToJson(this);
}
