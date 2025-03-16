import 'package:drill_events/common/utils/json_converters.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class SessionModel extends Equatable {
  const SessionModel({required this.tokens});

  factory SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);

  final TokensModel tokens;

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  @override
  List<Object?> get props => [tokens];
}

@JsonSerializable()
class TokensModel extends Equatable {
  const TokensModel({required this.accessToken, required this.refreshToken});

  factory TokensModel.fromJson(Map<String, dynamic> json) => _$TokensModelFromJson(json);

  final String accessToken;
  final String refreshToken;

  Map<String, dynamic> toJson() => _$TokensModelToJson(this);

  @override
  List<Object?> get props => [accessToken, refreshToken];
}

@JsonSerializable()
class UserInfoModel extends Equatable {
  const UserInfoModel({this.name, this.phone, this.telegram, this.whatsapp, this.vk});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);

  final String? name;
  final String? phone;
  final String? telegram;
  final String? whatsapp;
  final String? vk;

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);

  @override
  List<Object?> get props => [name, phone, telegram, whatsapp, vk];
}

@JsonSerializable()
class UserModel extends Equatable {
  const UserModel({required this.id, required this.email, required this.info});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  final String id;
  final String email;
  final UserInfoModel info;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [id, email, info];
}

@JsonSerializable()
class ShortUserModel extends Equatable {
  const ShortUserModel({required this.id, required this.email, this.name});

  factory ShortUserModel.fromJson(Map<String, dynamic> json) => _$ShortUserModelFromJson(json);

  final String id;
  final String email;
  final String? name;

  Map<String, dynamic> toJson() => _$ShortUserModelToJson(this);

  @override
  List<Object?> get props => [id, email, name];
}

@JsonSerializable()
class DetailOrgModel extends Equatable {
  const DetailOrgModel({required this.id, required this.title, required this.description});

  factory DetailOrgModel.fromJson(Map<String, dynamic> json) => _$DetailOrgModelFromJson(json);

  final String id;
  final String title;
  final String description;

  Map<String, dynamic> toJson() => _$DetailOrgModelToJson(this);

  @override
  List<Object?> get props => [id, title, description];
}

@JsonSerializable()
class OrgCardModel extends Equatable {
  const OrgCardModel({required this.id, required this.title, required this.eventsCount});

  factory OrgCardModel.fromJson(Map<String, dynamic> json) => _$OrgCardModelFromJson(json);

  final String id;
  final String title;
  final int eventsCount;

  Map<String, dynamic> toJson() => _$OrgCardModelToJson(this);

  @override
  List<Object?> get props => [id, title, eventsCount];
}

@JsonSerializable()
class ShortOrgModel extends Equatable {
  const ShortOrgModel({required this.id, required this.title});

  factory ShortOrgModel.fromJson(Map<String, dynamic> json) => _$ShortOrgModelFromJson(json);

  final String id;
  final String title;

  Map<String, dynamic> toJson() => _$ShortOrgModelToJson(this);

  @override
  List<Object?> get props => [id, title];
}

@JsonSerializable()
class DetailSpotModel extends Equatable {
  const DetailSpotModel({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.cityId,
    required this.org,
    this.subscribed,
  });

  factory DetailSpotModel.fromJson(Map<String, dynamic> json) => _$DetailSpotModelFromJson(json);

  final String id;
  final String title;
  final String description;
  final String address;
  final int cityId;
  final bool? subscribed;
  final ShortOrgModel org;

  Map<String, dynamic> toJson() => _$DetailSpotModelToJson(this);

  @override
  List<Object?> get props => [id, title, description, address, cityId, subscribed, org];
}

@JsonSerializable()
class SpotCardModel extends Equatable {
  const SpotCardModel({
    required this.id,
    required this.title,
    required this.address,
    required this.cityId,
    required this.subscribed,
    required this.org,
    this.city,
  });

  factory SpotCardModel.fromJson(Map<String, dynamic> json) => _$SpotCardModelFromJson(json);

  final String id;
  final String title;
  final String address;
  final int cityId;
  final bool? subscribed;
  final ShortOrgModel org;
  final String? city;

  Map<String, dynamic> toJson() => _$SpotCardModelToJson(this);

  @override
  List<Object?> get props => [id, title, address, cityId, subscribed, org];

  SpotCardModel copyWith({
    String? id,
    String? title,
    String? address,
    int? cityId,
    bool? subscribed,
    ShortOrgModel? org,
    String? city,
  }) => SpotCardModel(
    id: id ?? this.id,
    title: title ?? this.title,
    address: address ?? this.address,
    cityId: cityId ?? this.cityId,
    subscribed: subscribed ?? this.subscribed,
    org: org ?? this.org,
    city: city ?? this.city,
  );
}

@JsonSerializable()
class SpotSubscriptionCard extends Equatable {
  const SpotSubscriptionCard({
    required this.id,
    required this.title,
    required this.address,
    required this.cityId,
    required this.org,
  });

  factory SpotSubscriptionCard.fromJson(Map<String, dynamic> json) => _$SpotSubscriptionCardFromJson(json);

  final String id;
  final String title;
  final String address;
  final int cityId;
  final ShortOrgModel org;

  Map<String, dynamic> toJson() => _$SpotSubscriptionCardToJson(this);

  @override
  List<Object?> get props => [id, title, address, cityId, org];
}

@JsonSerializable()
class ShortSpotModel extends Equatable {
  const ShortSpotModel({required this.id, required this.title, required this.address, required this.cityId});

  factory ShortSpotModel.fromJson(Map<String, dynamic> json) => _$ShortSpotModelFromJson(json);

  final String id;
  final String title;
  final String address;
  final int cityId;

  Map<String, dynamic> toJson() => _$ShortSpotModelToJson(this);

  @override
  List<Object?> get props => [id, title, address, cityId];
}

@JsonSerializable()
class BookingModel extends Equatable {
  const BookingModel({required this.eventId, required this.usrId, required this.createdAt, this.approved, this.reason});

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

  final String eventId;
  final String usrId;
  final bool? approved;
  final String? reason;
  final String createdAt;

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  @override
  List<Object?> get props => [eventId, usrId, approved, reason, createdAt];
}

@JsonSerializable()
class ShortBookingModel extends Equatable {
  const ShortBookingModel({this.approved, this.reason});

  factory ShortBookingModel.fromJson(Map<String, dynamic> json) => _$ShortBookingModelFromJson(json);

  final bool? approved;
  final String? reason;

  Map<String, dynamic> toJson() => _$ShortBookingModelToJson(this);

  @override
  List<Object?> get props => [approved, reason];
}

@JsonSerializable()
class DetailEventModel extends Equatable {
  const DetailEventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.capacity,
    required this.availableSeats,
    required this.org,
    required this.spot,
    required this.startTime,
    this.spotCity,
    this.endTime,
    this.booking,
  });

  factory DetailEventModel.fromJson(Map<String, dynamic> json) => _$DetailEventModelFromJson(json);

  final String id;
  final String title;
  final String description;
  final String startDate;
  final String startTime;
  final String? spotCity;
  final String? endTime;
  final int capacity;
  final int availableSeats;
  final ShortOrgModel org;
  final ShortSpotModel spot;
  final ShortBookingModel? booking;

  Map<String, dynamic> toJson() => _$DetailEventModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    startDate,
    startTime,
    endTime,
    capacity,
    availableSeats,
    org,
    spot,
    booking,
  ];

  DetailEventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? startDate,
    String? startTime,
    String? endTime,
    String? spotCity,
    int? capacity,
    int? availableSeats,
    ShortOrgModel? org,
    ShortSpotModel? spot,
    ShortBookingModel? booking,
  }) => DetailEventModel(
    spotCity: spotCity ?? this.spotCity,
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    capacity: capacity ?? this.capacity,
    availableSeats: availableSeats ?? this.availableSeats,
    org: org ?? this.org,
    spot: spot ?? this.spot,
    startDate: startDate ?? this.startDate,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    booking: booking ?? this.booking,
  );
}

@JsonSerializable()
class EventCardModel extends Equatable {
  const EventCardModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.availableSeats,
    required this.org,
    required this.spot,
    required this.startTime,
    this.endTime,
    this.booking,
  });

  factory EventCardModel.fromJson(Map<String, dynamic> json) => _$EventCardModelFromJson(json);

  final String id;
  final String title;
  final DateTime startDate;
  final DateTime startTime;
  final String? endTime;
  final int availableSeats;
  final ShortOrgModel org;
  final ShortSpotModel spot;
  final ShortBookingModel? booking;

  Map<String, dynamic> toJson() => _$EventCardModelToJson(this);

  @override
  List<Object?> get props => [id, title, startDate, startTime, endTime, availableSeats, org, spot, booking];
}

@JsonSerializable()
class CityModel extends Equatable {
  const CityModel({required this.id, required this.title});

  factory CityModel.fromJson(Map<String, dynamic> json) => _$CityModelFromJson(json);

  final int id;
  final String title;

  Map<String, dynamic> toJson() => _$CityModelToJson(this);

  @override
  List<Object?> get props => [id, title];
}

@JsonSerializable()
class PaginationModel extends Equatable {
  const PaginationModel({
    required this.page,
    required this.size,
    required this.next,
    required this.itemCount,
    required this.pageCount,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) => _$PaginationModelFromJson(json);

  final int page;
  final int size;
  final bool next;
  final int itemCount;
  final int pageCount;

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  @override
  List<Object?> get props => [page, size, next, itemCount, pageCount];
}

@JsonSerializable(fieldRename: FieldRename.snake)
final class NewEventModel extends Equatable {
  const NewEventModel({
    this.title,
    this.spotId,
    this.startDate,
    this.description,
    this.endTime,
    this.startTime,
    this.expectingOptions,
    this.suggestOptions,
    this.capacity = 0,
  });

  factory NewEventModel.fromJson(Map<String, dynamic> json) => _$NewEventModelFromJson(json);

  final int? capacity;
  final String? spotId, title, description;

  @ToRFC3337DateConverter()
  final DateTime? startDate;
  @ToRFC3337TimeConverter()
  final DateTime? startTime;
  @ToRFC3337TimeConverter()
  final DateTime? endTime;

  final Iterable<String>? expectingOptions, suggestOptions;

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
    suggestOptions,
  ];

  Map<String, dynamic> toJson() => _$NewEventModelToJson(this);
}
