import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable(createToJson: false)
final class UserInfo extends Equatable {
  const UserInfo({
    required this.phone,
    required this.imgUrl,
    required this.name,
    required this.instagram,
    required this.telegram,
    required this.vk,
    required this.whatsApp,
  });

  @JsonKey(defaultValue: '')
  final String imgUrl;
  @JsonKey(defaultValue: '')
  final String phone;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String instagram;
  @JsonKey(defaultValue: '')
  final String telegram;
  @JsonKey(defaultValue: '')
  final String vk;
  @JsonKey(defaultValue: '')
  final String whatsApp;

  factory UserInfo.fromJson(Map<String, dynamic> jsom) => _$UserInfoFromJson(jsom);

  @override
  List<Object?> get props => [imgUrl, phone, name, instagram, telegram, vk, whatsApp];
}
