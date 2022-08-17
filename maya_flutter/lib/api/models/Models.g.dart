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
    );

Map<String, dynamic> _$GuestToJson(Guest instance) => <String, dynamic>{
      'type': _$GuestTypeEnumMap[instance.type],
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
      event_id: json['event_id'] as String,
      display_name: json['display_name'] as String,
      description: json['description'] as String?,
      date_start:
          TimeStamp.fromJson(json['date_start'] as Map<String, dynamic>),
      date_end: json['date_end'] == null
          ? null
          : TimeStamp.fromJson(json['date_end'] as Map<String, dynamic>),
      available_at: json['available_at'] == null
          ? null
          : TimeStamp.fromJson(json['available_at'] as Map<String, dynamic>),
      capacity: json['capacity'] as int?,
      taken_capacity: json['taken_capacity'] as int,
      required_reservation: json['required_reservation'] == null
          ? null
          : ReservableEvent.fromJson(
              json['required_reservation'] as Map<String, dynamic>),
      reservable_ticket_type: (json['reservable_ticket_type'] as List<dynamic>)
          .map((e) => TicketType.fromJson(e as Map<String, dynamic>))
          .toList(),
      require_two_factor: json['require_two_factor'] as bool,
    )..maximum_reservations_per_user =
        json['maximum_reservations_per_user'] as int?;

Map<String, dynamic> _$ReservableEventToJson(ReservableEvent instance) =>
    <String, dynamic>{
      'event_id': instance.event_id,
      'display_name': instance.display_name,
      'description': instance.description,
      'date_start': instance.date_start,
      'date_end': instance.date_end,
      'available_at': instance.available_at,
      'capacity': instance.capacity,
      'taken_capacity': instance.taken_capacity,
      'required_reservation': instance.required_reservation,
      'reservable_ticket_type': instance.reservable_ticket_type,
      'require_two_factor': instance.require_two_factor,
      'maximum_reservations_per_user': instance.maximum_reservations_per_user,
    };

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      reservation_id: json['reservation_id'] as String,
      event: ReservableEvent.fromJson(json['event'] as Map<String, dynamic>),
      tickets: (json['tickets'] as List<dynamic>)
          .map((e) => Ticket.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'reservation_id': instance.reservation_id,
      'event': instance.event,
      'tickets': instance.tickets,
    };

MayaUser _$MayaUserFromJson(Map<String, dynamic> json) => MayaUser(
      json['firstName'] as String,
      json['lastName'] as String,
      TimeStamp.fromJson(json['createdDate'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MayaUserToJson(MayaUser instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'createdDate': instance.createdDate,
    };

TimeStamp _$TimeStampFromJson(Map<String, dynamic> json) => TimeStamp(
      json['_seconds'] as int,
      json['_nanoseconds'] as int,
    );

Map<String, dynamic> _$TimeStampToJson(TimeStamp instance) => <String, dynamic>{
      '_seconds': instance.seconds,
      '_nanoseconds': instance.nanoseconds,
    };

UserAuthentication _$UserAuthenticationFromJson(Map<String, dynamic> json) =>
    UserAuthentication(
      json['firebase_auth_uid'] as String,
    );

Map<String, dynamic> _$UserAuthenticationToJson(UserAuthentication instance) =>
    <String, dynamic>{
      'firebase_auth_uid': instance.firebase_auth_uid,
    };

Reference _$ReferenceFromJson(Map<String, dynamic> json) => Reference(
      FireStore.fromJson(json['_firestore'] as Map<String, dynamic>),
      Path.fromJson(json['_path'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReferenceToJson(Reference instance) => <String, dynamic>{
      '_firestore': instance.fireStore,
      '_path': instance.path,
    };

FireStore _$FireStoreFromJson(Map<String, dynamic> json) => FireStore(
      json['projectId'] as String,
    );

Map<String, dynamic> _$FireStoreToJson(FireStore instance) => <String, dynamic>{
      'projectId': instance.projectId,
    };

Path _$PathFromJson(Map<String, dynamic> json) => Path(
      (json['segments'] as List<dynamic>).map((e) => e as String).toList(),
      json['_converter'],
    );

Map<String, dynamic> _$PathToJson(Path instance) => <String, dynamic>{
      'segments': instance.segments,
      '_converter': instance.converter,
    };

TicketType _$TicketTypeFromJson(Map<String, dynamic> json) => TicketType(
      ticket_type_id: json['ticket_type_id'] as String,
      reservable_group:
          Group.fromJson(json['reservable_group'] as Map<String, dynamic>),
      display_ticket_name: json['display_ticket_name'] as String,
      display_ticket_description: json['display_ticket_description'] as String?,
    );

Map<String, dynamic> _$TicketTypeToJson(TicketType instance) =>
    <String, dynamic>{
      'ticket_type_id': instance.ticket_type_id,
      'reservable_group': instance.reservable_group,
      'display_ticket_name': instance.display_ticket_name,
      'display_ticket_description': instance.display_ticket_description,
    };

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      room_id: json['room_id'] as String,
      capacity: json['capacity'] as int,
      display_name: json['display_name'] as String,
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'room_id': instance.room_id,
      'capacity': instance.capacity,
      'display_name': instance.display_name,
    };

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
      ticket_id: json['ticket_id'] as String,
      ticket_type:
          TicketType.fromJson(json['ticket_type'] as Map<String, dynamic>),
      event: ReservableEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'ticket_id': instance.ticket_id,
      'ticket_type': instance.ticket_type,
      'event': instance.event,
    };
