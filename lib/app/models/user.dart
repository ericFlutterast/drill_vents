import 'package:drill_events/app/models/user_info.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(createToJson: false)
final class UserModel extends Equatable {
  const UserModel({required this.userId, required this.email, required this.info});

  factory UserModel.empty() => const UserModel(
    userId: '',
    email: '',
    info: UserInfo(phone: '', imgUrl: '', name: '', instagram: '', telegram: '', vk: '', whatsApp: ''),
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  @JsonKey(name: 'id')
  final String userId;
  @JsonKey(defaultValue: '')
  final String email;
  final UserInfo info;

  @override
  List<Object?> get props => [userId, email, info];
}
