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

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable()
class Guest {
  GuestType type;
  Group relatingGroup;

  Guest(this.type, this.relatingGroup);

  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);

  Map<String, dynamic> toJson() => _$GuestToJson(this);
}

enum GuestType {
  @JsonValue("Adult")
  Adult("Adult"),
  @JsonValue("Child")
  Child("Child"),
  @JsonValue("Parent")
  Parent("Parent"),
  @JsonValue("Student")
  Student("Student"),
  @JsonValue("Staff")
  Staff("Staff");

  final String value;

  const GuestType(this.value);
}

@JsonSerializable()
class ReservableEvent {
  int event_id;
  String display_name;
  String? description;
  TimeStamp date_start;
  TimeStamp? date_end;
  TimeStamp? available_at;
  int? capacity;
  int taken_capacity;
  List<String> reservations;
  Reservation? required_reservation;

  ReservableEvent(this.event_id, this.display_name, this.description, this.date_start, this.date_end, this.available_at, this.capacity, this.taken_capacity, this.reservations, this.required_reservation);

  factory ReservableEvent.fromJson(Map<String, dynamic> json) => _$ReservableEventFromJson(json);

  Map<String, dynamic> toJson() => _$ReservableEventToJson(this);

  @override
  String toString(){
    return "イベント:$display_name";
  }
}

@JsonSerializable()
class Reservation {
  int reservation_id;
  ReservableEvent event;

  int member_all() {
    return group_data.headcount();
  }

  Group group_data;

  Reservation(this.reservation_id, this.event, this.group_data);

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
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
