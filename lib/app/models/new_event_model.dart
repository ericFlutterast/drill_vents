import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'new_event_model.g.dart';

@JsonSerializable(createFactory: false, fieldRename: FieldRename.snake)
final class NewEventModel extends Equatable {
  const NewEventModel({
    this.title,
    this.spotId,
    this.startDate,
    this.description,
    this.endTime,
    this.startTime,
    this.expectingOptions,
    this.weSuggestOptions,
    this.capacity = 0,
  });

  final int capacity;
  final String? spotId, title, description, startDate, startTime, endTime;
  final Iterable<String>? expectingOptions, weSuggestOptions;

  @override
  List<Object?> get props => [
    spotId,
    title,
    description,
    startDate,
    startTime,
    endTime,
    capacity,
    expectingOptions,
    weSuggestOptions,
  ];

  bool fieldsNoContainsNull() {
    for (final field in props) {
      if (field == null) return false;
    }
    return true;
  }

  NewEventModel copyWith({
    int? capacity,
    String? spotId,
    title,
    description,
    startDate,
    startTime,
    endTime,
    Iterable<String>? expectingOptions,
    weSuggestOptions,
  }) => NewEventModel(
    capacity: capacity ?? this.capacity,
    spotId: spotId ?? this.spotId,
    title: title ?? this.title,
    description: description ?? this.description,
    startDate: startDate ?? this.startDate,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    expectingOptions: expectingOptions ?? this.expectingOptions,
    weSuggestOptions: weSuggestOptions ?? this.weSuggestOptions,
  );

  Map<String, dynamic> toJson() => _$NewEventModelToJson(this);
}
