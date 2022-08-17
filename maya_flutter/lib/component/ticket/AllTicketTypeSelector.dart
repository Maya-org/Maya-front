import 'package:flutter/material.dart';

import '../../api/models/Models.dart';

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
    return Column(children: _children());
  }

  List<Widget> _children() {
    List<Widget> children = _tickets.toList();
    if (widget.maximum_reservations_per_user != null) {
      children.add(Text("最大予約人数: ${widget.maximum_reservations_per_user!}人"));
    }
    for (TicketType type in widget.ticketTypes) {
      children.add(generateTicketTypeChild(type));
    }
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

  Widget generateTicketTypeChild(TicketType type) {
    return Row(
      children: [
        Expanded(child: Text(type.display_ticket_name)),
        ElevatedButton(
            onPressed: _getCount(type) == 0
                ? null
                : () {
                    _minus(type);
                  },
            child: const Text("-")),
        Text(_getCount(type).toString()),
        ElevatedButton(
            onPressed: () {
              _plus(type);
            },
            child: const Text("+")),
      ],
    );
  }

  void _plus(TicketType type) {
    setState(() {
      _selected[type.ticket_type_id] = _getCount(type) + 1;
    });
  }

  void _minus(TicketType type) {
    setState(() {
      _selected[type.ticket_type_id] = (_selected[type.ticket_type_id] ?? 0) - 1;
    });
  }

  int _getCount(TicketType type) {
    return _selected[type.ticket_type_id] ?? 0;
  }

  int _allHeadCount() {
    int count = 0;
    for (var type in widget.ticketTypes) {
      count += _getCount(type);
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
