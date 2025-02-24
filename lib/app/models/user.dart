import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
final class UserModel extends Equatable {
  const UserModel({
    required this.userId,
    required this.imgUrl,
    required this.phone,
    required this.name,
    required this.instagram,
    required this.telegram,
    required this.vk,
    required this.whatsApp,
    required this.email,
  });

  factory UserModel.empty() => const UserModel(
    userId: '',
    imgUrl: '',
    phone: '',
    name: '',
    instagram: '',
    telegram: '',
    vk: '',
    whatsApp: '',
    email: '',
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  final String userId;
  @JsonKey(defaultValue: '', name: 'user_id')
  final String name;
  @JsonKey(defaultValue: '', name: 'img_name')
  final String imgUrl;
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: '')
  final String phone;
  @JsonKey(defaultValue: '')
  final String telegram;
  @JsonKey(defaultValue: '')
  final String whatsApp;
  @JsonKey(defaultValue: '')
  final String instagram;
  @JsonKey(defaultValue: '')
  final String vk;

  @override
  List<Object?> get props => [userId, imgUrl, phone, name, instagram, telegram, vk, whatsApp, email];

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
