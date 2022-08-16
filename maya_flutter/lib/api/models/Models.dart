import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Models.g.dart';

@JsonSerializable()
class Group {
  List<Guest> all_guests;

  int headcount() {
    return all_guests.length;
  }

  Group(this.all_guests);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  factory Group.fromMap(Map<GuestType, int> map) {
    List<Guest> guests = [];
    for (GuestType type in GuestType.values) {
      if (map[type] == null) {
        continue;
      }
      for (int i = 0; i < map[type]!; i++) {
        guests.add(Guest(type));
      }
    }
    return Group(guests);
  }

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  int getGuestCount(GuestType type) {
    return all_guests.where((g) => g.type == type).length;
  }

  @override
  String toString() {
    return '{all_guests: [${all_guests.map((e) => e.type).join(', ')}]}';
  }

  String prettyPrint() {
    String s = "";
    for (GuestType type in GuestType.values) {
      if (getGuestCount(type) == 0) {
        continue;
      }
      s += "${type.pretty} ${getGuestCount(type)}人";
    }
    return s;
  }
}

@JsonSerializable()
class Guest {
  GuestType type;

  Guest(this.type);

  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);

  Map<String, dynamic> toJson() => _$GuestToJson(this);
}

enum GuestType {
  @JsonValue("Adult")
  Adult("Adult", "大人"),
  @JsonValue("Child")
  Child("Child", "子供"),
  @JsonValue("Parent")
  Parent("Parent", "保護者"),
  @JsonValue("Student")
  Student("Student", "内部生"),
  @JsonValue("Staff")
  Staff("Staff", "スタッフ");

  final String value;
  final String pretty;

  const GuestType(this.value, this.pretty);
}

@JsonSerializable()
class ReservableEvent {
  String event_id;
  String display_name;
  String? description;
  TimeStamp date_start;
  TimeStamp? date_end;
  TimeStamp? available_at;
  int? capacity;
  int taken_capacity;
  ReservableEvent?
      required_reservation; // Reference to a reservation that is required to attend this event.
  List<TicketType> reservable_ticket_type;

  ReservableEvent(
      {required this.event_id,
      required this.display_name,
      this.description,
      required this.date_start,
      this.date_end,
      this.available_at,
      this.capacity,
      required this.taken_capacity,
      this.required_reservation,
      required this.reservable_ticket_type});

  factory ReservableEvent.fromJson(Map<String, dynamic> json) => _$ReservableEventFromJson(json);

  Map<String, dynamic> toJson() => _$ReservableEventToJson(this);

  @override
  String toString() {
    return "{イベント:$display_name,id:$event_id,開始:$date_start,終了:$date_end,最大参加人数$capacity,参加人数:$taken_capacity,必要予約:$required_reservation,予約可能:$reservable_ticket_type}";
  }
}

@JsonSerializable()
class Reservation {
  String reservation_id;
  ReservableEvent event;

  int member_all() {
    return group_data.headcount();
  }

  Group group_data;
  TicketType reserved_ticket_type;

  Reservation(
      {required this.reservation_id,
      required this.event,
      required this.group_data,
      required this.reserved_ticket_type});

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);

  @override
  String toString() {
    return "{予約:$reservation_id,イベント:$event,参加人数:${member_all()},チケット:$reserved_ticket_type}";
  }
}

@JsonSerializable()
class MayaUser {
  String firstName;
  String lastName;
  TimeStamp createdDate;

  MayaUser(this.firstName, this.lastName, this.createdDate);

  factory MayaUser.fromJson(Map<String, dynamic> json) => _$MayaUserFromJson(json);

  Map<String, dynamic> toJson() => _$MayaUserToJson(this);
}

@JsonSerializable()
class TimeStamp {
  @JsonKey(name: '_seconds')
  int seconds;
  @JsonKey(name: '_nanoseconds')
  int nanoseconds;

  TimeStamp(this.seconds, this.nanoseconds);

  factory TimeStamp.fromJson(Map<String, dynamic> json) => _$TimeStampFromJson(json);

  Map<String, dynamic> toJson() => _$TimeStampToJson(this);

  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }

  static now() {
    return TimeStamp(DateTime.now().millisecondsSinceEpoch ~/ 1000,
        DateTime.now().millisecondsSinceEpoch % 1000);
  }
}

@JsonSerializable()
class UserAuthentication {
  String firebase_auth_uid;

  UserAuthentication(this.firebase_auth_uid);

  static UserAuthentication? getCurrent() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    } else {
      return UserAuthentication(user.uid);
    }
  }

  factory UserAuthentication.fromJson(Map<String, dynamic> json) =>
      _$UserAuthenticationFromJson(json);

  Map<String, dynamic> toJson() => _$UserAuthenticationToJson(this);
}

@JsonSerializable()
class Reference {
  @JsonKey(name: '_firestore')
  FireStore fireStore;
  @JsonKey(name: '_path')
  Path path;

  Reference(this.fireStore, this.path);

  factory Reference.fromJson(Map<String, dynamic> json) => _$ReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ReferenceToJson(this);
}

@JsonSerializable()
class FireStore {
  String projectId;

  FireStore(this.projectId);

  factory FireStore.fromJson(Map<String, dynamic> json) => _$FireStoreFromJson(json);

  Map<String, dynamic> toJson() => _$FireStoreToJson(this);
}

@JsonSerializable()
class Path {
  List<String> segments;
  @JsonKey(name: '_converter')
  dynamic converter;

  Path(this.segments, this.converter);

  factory Path.fromJson(Map<String, dynamic> json) => _$PathFromJson(json);

  Map<String, dynamic> toJson() => _$PathToJson(this);
}

@JsonSerializable()
class ReserveRequest {
  String event_id;
  Group group;
  String ticket_type_id;

  ReserveRequest({required this.event_id, required this.group, required this.ticket_type_id});

  factory ReserveRequest.fromJson(Map<String, dynamic> json) => _$ReserveRequestFromJson(json);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'event_id': event_id,
        'group': group.toJson(),
        'ticket_type_id': ticket_type_id,
      };

  ReserveRequest.fromEvent(ReservableEvent event, Group group)
      : this(
            event_id: event.event_id,
            group: group,
            ticket_type_id: event.reservable_ticket_type[0].ticket_type_id);
}

@JsonSerializable()
class TicketType {
  String ticket_type_id;
  List<Group> reservable_group;
  String display_ticket_name;
  String? display_ticket_description;
  bool require_two_factor;

  TicketType(
      {required this.ticket_type_id,
      required this.reservable_group,
      required this.display_ticket_name,
      this.display_ticket_description,
      required this.require_two_factor});

  factory TicketType.fromJson(Map<String, dynamic> json) => _$TicketTypeFromJson(json);

  Map<String, dynamic> toJson() => _$TicketTypeToJson(this);

  @override
  String toString() {
    return "{チケットタイプ:$ticket_type_id,グループ:[${reservable_group.map((g) => g.toString()).join(',')}],表示名:$display_ticket_name,説明:$display_ticket_description,2FA:$require_two_factor}";
  }
}
