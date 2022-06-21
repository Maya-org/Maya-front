// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      (json['all_guests'] as List<dynamic>)
          .map((e) => Guest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'all_guests': instance.all_guests,
    };

Guest _$GuestFromJson(Map<String, dynamic> json) => Guest(
      $enumDecode(_$GuestTypeEnumMap, json['type']),
      Group.fromJson(json['relatingGroup'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GuestToJson(Guest instance) => <String, dynamic>{
      'type': _$GuestTypeEnumMap[instance.type],
      'relatingGroup': instance.relatingGroup,
    };

const _$GuestTypeEnumMap = {
  GuestType.Adult: 'Adult',
  GuestType.Child: 'Child',
  GuestType.Parent: 'Parent',
  GuestType.Student: 'Student',
  GuestType.Staff: 'Staff',
};

ReservableEvent _$ReservableEventFromJson(Map<String, dynamic> json) =>
    ReservableEvent(
      json['event_id'] as int,
      json['display_name'] as String,
      json['description'] as String?,
      Dating.fromJson(json['dating'] as Map<String, dynamic>),
      json['capacity'] as int?,
      json['taken_capacity'] as int,
      (json['reservations'] as List<dynamic>)
          .map((e) => Reservation.fromJson(e as Map<String, dynamic>))
          .toList(),
      Reservation.fromJson(
          json['required_reservation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReservableEventToJson(ReservableEvent instance) =>
    <String, dynamic>{
      'event_id': instance.event_id,
      'display_name': instance.display_name,
      'description': instance.description,
      'dating': instance.dating,
      'capacity': instance.capacity,
      'taken_capacity': instance.taken_capacity,
      'reservations': instance.reservations,
      'required_reservation': instance.required_reservation,
    };

Dating _$DatingFromJson(Map<String, dynamic> json) => Dating(
      DateTime.parse(json['date_start'] as String),
      json['date_end'] == null
          ? null
          : DateTime.parse(json['date_end'] as String),
      json['available_at'] == null
          ? null
          : DateTime.parse(json['available_at'] as String),
    );

Map<String, dynamic> _$DatingToJson(Dating instance) => <String, dynamic>{
      'date_start': instance.date_start.toIso8601String(),
      'date_end': instance.date_end?.toIso8601String(),
      'available_at': instance.available_at?.toIso8601String(),
    };

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      json['reservation_id'] as int,
      ReservableEvent.fromJson(json['event'] as Map<String, dynamic>),
      Group.fromJson(json['group_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'reservation_id': instance.reservation_id,
      'event': instance.event,
      'group_data': instance.group_data,
    };

MayaUser _$MayaUserFromJson(Map<String, dynamic> json) => MayaUser(
      json['firstName'] as String,
      json['lastName'] as String,
      DateTime.parse(json['createdAt'] as String),
      UserAuthentication.fromJson(json['auth'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MayaUserToJson(MayaUser instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'createdAt': instance.createdAt.toIso8601String(),
      'auth': instance.auth,
    };

UserAuthentication _$UserAuthenticationFromJson(Map<String, dynamic> json) =>
    UserAuthentication(
      json['firebase_auth_uid'] as String,
    );

Map<String, dynamic> _$UserAuthenticationToJson(UserAuthentication instance) =>
    <String, dynamic>{
      'firebase_auth_uid': instance.firebase_auth_uid,
    };