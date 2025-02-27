import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'organization.g.dart';

@JsonSerializable()
final class OrganizationModel extends Equatable {
  const OrganizationModel({
    required this.organizationId,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @JsonKey(name: 'id')
  final String organizationId;
  final String title;
  final String? description, imageUrl;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) => _$OrganizationModelFromJson(json);

  @override
  List<Object?> get props => [organizationId, title, description, imageUrl];

  Map<String, dynamic> toJson() => _$OrganizationModelToJson(this);
}
