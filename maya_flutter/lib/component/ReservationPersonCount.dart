import 'package:flutter/material.dart';

import '../api/models/Models.dart';

/// List<TicketType>の中身の人数を表示する
class ReservationPersonCount extends StatelessWidget {
  final List<TicketType> ticketTypes;

  const ReservationPersonCount({super.key, required this.ticketTypes});

  @override
  Widget build(BuildContext context) {
    return Text("""
大人:${_getGuestCount(GuestType.Adult, ticketTypes)}人
子供:${_getGuestCount(GuestType.Child, ticketTypes)}人
保護者:${_getGuestCount(GuestType.Parent, ticketTypes)}人
生徒:${_getGuestCount(GuestType.Student, ticketTypes)}人""");
  }

  int _getGuestCount(GuestType guestType, List<TicketType> ticketTypes) {
    int count = 0;
    for (Guest guest in ticketTypes
        .map((e) => e.reservable_group)
        .map((e) => e.all_guests)
        .expand((e) => e)) {
      if (guest.type == guestType) {
        count++;
      }
    }
    return count;
  }
}