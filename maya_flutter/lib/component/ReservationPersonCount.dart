import 'package:flutter/material.dart';

import '../api/models/Models.dart';

/// List<TicketType>の中身の人数を表示する
class ReservationPersonCount extends StatelessWidget {
  final int adult;
  final int child;
  final int parent;
  final int student;

  const ReservationPersonCount(
      {super.key,
      required this.adult,
      required this.child,
      required this.parent,
      required this.student});

  factory ReservationPersonCount.fromReservation(List<TicketType> ticketTypes) {
    return ReservationPersonCount(
      adult: getGuestCount(GuestType.Adult, ticketTypes),
      child: getGuestCount(GuestType.Child, ticketTypes),
      parent: getGuestCount(GuestType.Parent, ticketTypes),
      student: getGuestCount(GuestType.Student, ticketTypes),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text("""
大人:$adult人
子供:$child人
保護者:$parent人
生徒:$student人
合計:${adult + child + parent + student}人""");
  }

  static int getGuestCount(GuestType guestType, List<TicketType> ticketTypes) {
    int count = 0;
    for (Guest guest
        in ticketTypes.map((e) => e.reservable_group).map((e) => e.all_guests).expand((e) => e)) {
      if (guest.type == guestType) {
        count++;
      }
    }
    return count;
  }
}
