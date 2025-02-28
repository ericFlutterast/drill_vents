import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'org.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
final class OrgModel extends Equatable {
  const OrgModel({required this.id, required this.title, required this.description});

  factory OrgModel.fromJson(Map<String, dynamic> json) => _$OrgModelFromJson(json);

  final String id, title, description;

  @override
  List<Object?> get props => [id, title, description];

  Map<String, dynamic> toJson() => _$OrgModelToJson(this);
}
