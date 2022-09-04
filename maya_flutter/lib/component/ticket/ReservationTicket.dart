import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../api/models/Models.dart';
import '../PageControllerVisualizer.dart';
import 'TicketElement.dart';

class ReservationTicket extends StatefulWidget {
  final List<Ticket> tickets;
  final String? uid;

  const ReservationTicket({super.key, required this.tickets, required this.uid});

  @override
  State<ReservationTicket> createState() => _ReservationTicketState();
}

class _ReservationTicketState extends State<ReservationTicket> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(children: [
        SizedBox(
            height: 50, child: PageControllerVisualizer(_pageController, widget.tickets.length)),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
                width: min(constraints.maxWidth, 500),
                height: min(constraints.maxWidth, 500) + 20 + 48 + 2,
                child: PageView.builder(
                    itemBuilder: _builder,
                    itemCount: widget.tickets.length,
                    controller: _pageController));
          },
        ),
      ]),
    );
  }

  Widget _builder(BuildContext context, int index) {
    Ticket ticket = widget.tickets[index];
    return TicketElement(ticket: ticket, uid: widget.uid);
  }
}
