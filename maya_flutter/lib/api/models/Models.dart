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
    return all_guests
        .where((g) => g.type == type)
        .length;
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
  bool require_two_factor;
  int? maximum_reservations_per_user;

  ReservableEvent({required this.event_id,
    required this.display_name,
    this.description,
    required this.date_start,
    this.date_end,
    this.available_at,
    this.capacity,
    required this.taken_capacity,
    this.required_reservation,
    required this.reservable_ticket_type,
    required this.require_two_factor
  });

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
  List<Ticket> tickets;

  int headCount(){
    int count = 0;
    for (var element in tickets) { count += element.ticket_type.reservable_group.headcount(); }
    return count;
  }


  Reservation({required this.reservation_id,
    required this.event,
    required this.tickets});

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);

  @override
  String toString() {
    return "{予約:$reservation_id,イベント:$event,チケット枚数:${tickets.length}}";
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
    return TimeStamp(DateTime
        .now()
        .millisecondsSinceEpoch ~/ 1000,
        DateTime
            .now()
            .millisecondsSinceEpoch % 1000);
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

class ReserveRequest {
  String event_id;
  String? two_factor_key;
  List<TicketType> tickets;


  ReserveRequest({required this.event_id,
    this.two_factor_key,
    required this.tickets});

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'event_id': event_id,
        'tickets': tickets,
        if (two_factor_key != null) 'two_factor_key': two_factor_key,
      };
}

@JsonSerializable()
class TicketType {
  String ticket_type_id;
  Group reservable_group;
  String display_ticket_name;
  String? display_ticket_description;

  TicketType({required this.ticket_type_id,
    required this.reservable_group,
    required this.display_ticket_name,
    this.display_ticket_description,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) => _$TicketTypeFromJson(json);

  Map<String, dynamic> toJson() => _$TicketTypeToJson(this);

  @override
  String toString() {
    return "{チケットタイプ:$ticket_type_id,グループ:$reservable_group,表示名:$display_ticket_name,説明:$display_ticket_description}";
  }
}

enum Operation {
  @JsonValue('Enter')
  Enter("入場", "enter"),
  @JsonValue('Exit')
  Exit("出場", "exit");

  final String displayName;
  final String operationName;

  const Operation(this.displayName, this.operationName);
}

@JsonSerializable()
class Room {
  String room_id;
  int capacity;
  String display_name;

  Room({required this.room_id, required this.capacity, required this.display_name});

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  @override
  String toString() {
    return "{ルームID:$room_id,定員:$capacity,表示名:$display_name}";
  }
}

@JsonSerializable()
class Ticket {
  String ticket_id;
  TicketType ticket_type;
  ReservableEvent event;

  Ticket(
      {required this.ticket_id, required this.ticket_type, required this.event});

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  Map<String, dynamic> toJson() => _$TicketToJson(this);
}