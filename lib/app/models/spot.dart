import 'package:drill_events/app/models/event.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'spot.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SpotModel extends Equatable {
  const SpotModel({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.cityId,
    this.events = const [],
  });

  factory SpotModel.fromJson(Map<String, dynamic> json) => _$SpotModelFromJson(json);

  final String id, title, description, address;
  final int cityId;
  final List<EventModel> events;

  SpotModel copyWith({List<EventModel>? events}) => SpotModel(
    id: id,
    title: title,
    description: description,
    address: address,
    cityId: cityId,
    events: events ?? this.events,
  );

  @override
  List<Object?> get props => [id, title, description, address, cityId, events];

  Map<String, dynamic> toJson() => _$SpotModelToJson(this);
}
