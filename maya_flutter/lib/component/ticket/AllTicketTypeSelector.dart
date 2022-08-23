import 'dart:math';

import 'package:flutter/material.dart';

import '../../api/models/Models.dart';
import '../ReservationPersonCount.dart';

class AllTicketTypeSelector extends StatefulWidget {
  final int? maximum_reservations_per_user;
  final List<TicketType> ticketTypes;
  final void Function(BuildContext context, List<TicketType> tickets) onSubmit;
  List<TicketType>? selected;

  AllTicketTypeSelector(
      {Key? key,
      required this.ticketTypes,
      required this.onSubmit,
      this.maximum_reservations_per_user,
      this.selected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AllTicketTypeSelectorState();
}

class _AllTicketTypeSelectorState extends State<AllTicketTypeSelector> {
  final List<Widget> _tickets = [];
  Map<String, int> _selected = {};

  @override
  void initState() {
    super.initState();
    if (widget.selected != null) {
      _selected = _genSelected(widget.selected!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(10), child: Column(children: _children()));
  }

  List<Widget> _children() {
    List<Widget> children = _tickets.toList();
    if (widget.maximum_reservations_per_user != null) {
      children.add(Text("最大予約人数: ${widget.maximum_reservations_per_user!}人"));
    }
    children.add(const SizedBox(height: 8));
    for (TicketType type in widget.ticketTypes) {
      children.add(generateTicketTypeChild(type));
      children.add(const SizedBox(height: 8));
    }
    children.add(ReservationPersonCount(
      adult: _getCountByType(GuestType.Adult),
      child: _getCountByType(GuestType.Child),
      parent: _getCountByType(GuestType.Parent),
      student: _getCountByType(GuestType.Student),
    ));
    children.add(ElevatedButton(
        onPressed: _allHeadCount() == 0 || _exceedsMaximumReservationsPerUser() ? null : _submit,
        child: const Text("確定")));
    return children;
  }

  void _submit() {
    List<TicketType> submission = _generateSubmission();
    widget.onSubmit(context, submission);
  }

  List<TicketType> _generateSubmission() {
    List<TicketType> submission = [];
    for (final ticketTypeId in _selected.keys) {
      TicketType type = widget.ticketTypes.firstWhere((e) => e.ticket_type_id == ticketTypeId);
      for (int i = 0; i < _selected[ticketTypeId]!; i++) {
        submission.add(type);
      }
    }

    return submission;
  }

  String _generateTitle(TicketType type) {
    return "${type.display_ticket_name}";
  }

  String _generateSubtitle(TicketType type) {
    String guestCount = "";
    for (var guestType in GuestType.values) {
      int count = type.reservable_group.getGuestCount(guestType);
      if (count == 0) {
        continue;
      }
      guestCount += "${guestType.pretty} $count人";
    }
    return """
${guestCount}""";
  }

  Widget generateTicketTypeChild(TicketType type) {
    return TicketTypeEntry(
      title: _generateTitle(type),
      subtitle: _generateSubtitle(type),
      onChanged: (int newValue) {
        setState(() {
          _selected[type.ticket_type_id] = newValue;
        });
      },
    );
  }

  int _getCount(TicketType type) {
    return _selected[type.ticket_type_id] ?? 0;
  }

  int _getCountByType(GuestType guestType) {
    int count = 0;
    for (var type in widget.ticketTypes) {
      count += _getCount(type) * type.reservable_group.getGuestCount(guestType);
    }

    return count;
  }

  int _allHeadCount() {
    int count = 0;
    for (var type in widget.ticketTypes) {
      count += _getCount(type) * type.reservable_group.headcount();
    }

    return count;
  }

  bool _exceedsMaximumReservationsPerUser() {
    if (widget.maximum_reservations_per_user == null) {
      return false;
    }
    return _allHeadCount() > widget.maximum_reservations_per_user!;
  }

  Map<String, int> _genSelected(List<TicketType> selected) {
    Map<String, int> selectedMap = {};
    for (TicketType type in selected) {
      selectedMap[type.ticket_type_id] = (selectedMap[type.ticket_type_id] ?? 0) + 1;
    }
    return selectedMap;
  }
}

class TicketTypeEntry extends StatefulWidget {
  final String title;
  final String subtitle;
  final void Function(int newValue) onChanged;

  const TicketTypeEntry(
      {Key? key, required this.title, required this.subtitle, required this.onChanged})
      : super(key: key);

  @override
  State<TicketTypeEntry> createState() => _TicketTypeEntryState();
}

class _TicketTypeEntryState extends State<TicketTypeEntry> {
  int _nowValue = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title),
                Text(
                  widget.subtitle,
                  style: const TextStyle(color: Color.fromARGB(255, 125, 125, 125)),
                ),
              ],
            ),
          )),
          TextButton(
              onPressed: _nowValue == 0
                  ? null
                  : () {
                      _minus();
                    },
              child: const Icon(Icons.remove_circle_outline)),
          Text(_nowValue.toString()),
          TextButton(
              onPressed: () {
                _plus();
              },
              child: const Icon(Icons.add_circle_outline)),
        ],
      ),
    );
  }

  void _minus() {
    setState(() {
      _nowValue = max(_nowValue - 1, 0);
    });
    widget.onChanged(_nowValue);
  }

  void _plus() {
    setState(() {
      _nowValue = _nowValue + 1;
    });
    widget.onChanged(_nowValue);
  }
}
