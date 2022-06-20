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
  Dating dating;
  int? capacity;
  int taken_capacity;
  List<Reservation> reservations;
  Reservation required_reservation;

  ReservableEvent(this.event_id, this.display_name, this.description, this.dating, this.capacity,
      this.taken_capacity, this.reservations, this.required_reservation);

  factory ReservableEvent.fromJson(Map<String, dynamic> json) => _$ReservableEventFromJson(json);

  Map<String, dynamic> toJson() => _$ReservableEventToJson(this);
}

@JsonSerializable()
class Dating {
  DateTime date_start;
  DateTime? date_end;
  DateTime? available_at;

  Dating(this.date_start, this.date_end, this.available_at);

  factory Dating.fromJson(Map<String, dynamic> json) => _$DatingFromJson(json);

  Map<String, dynamic> toJson() => _$DatingToJson(this);
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
  DateTime createdAt;
  UserAuthentication auth;

  MayaUser(this.firstName, this.lastName, this.createdAt, this.auth);

  factory MayaUser.fromJson(Map<String, dynamic> json) => _$MayaUserFromJson(json);

  Map<String, dynamic> toJson() => _$MayaUserToJson(this);
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

  factory UserAuthentication.fromJson(Map<String, dynamic> json) => _$UserAuthenticationFromJson(json);

  Map<String, dynamic> toJson() => _$UserAuthenticationToJson(this);
}
