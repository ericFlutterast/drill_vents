import 'package:drill_events/app/new_models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'states.g.dart';

@JsonSerializable()
class DetailOrgListSection extends Equatable {
  const DetailOrgListSection({this.events = const [], this.spots = const []});

  factory DetailOrgListSection.fromJson(Map<String, dynamic> json) => _$DetailOrgListSectionFromJson(json);

  final List<EventCardModel> events;
  final List<SpotCardModel> spots;

  Map<String, dynamic> toJson() => _$DetailOrgListSectionToJson(this);

  @override
  List<Object?> get props => [events, spots];
}
