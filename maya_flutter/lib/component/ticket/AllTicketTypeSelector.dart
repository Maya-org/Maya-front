import 'package:flutter/material.dart';
import 'package:maya_flutter/component/ticket/TicketTypeSelector.dart';

import '../../api/models/Models.dart';

class AllTicketTypeSelector extends StatefulWidget {
  final List<TicketType> ticketTypes;
  Map<int, TicketType> selected = {};
  final void Function(BuildContext context, List<TicketType> tickets) onSubmit;

  AllTicketTypeSelector({Key? key, required this.ticketTypes, required this.onSubmit})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AllTicketTypeSelectorState();
}

class _AllTicketTypeSelectorState extends State<AllTicketTypeSelector> {
  final List<Widget> _tickets = [];

  @override
  Widget build(BuildContext context) {
    return Column(children: _children());
  }

  List<Widget> _children() {
    List<Widget> children = _tickets.toList();
    children.add(ElevatedButton(onPressed: _addTicket, child: const Text("Add Ticket")));
    children.add(ElevatedButton(onPressed: widget.selected.isEmpty ? null : _submit, child: const Text("Submit")));
    return children;
  }

  void _addTicket() {
    setState(() {
      int index = _tickets.length;
      _tickets.add(TicketTypeSelector(
        ticketTypes: widget.ticketTypes,
        onChange: (TicketType newValue) {
          setState(() {
            widget.selected[index] = newValue;
          });
        },
      ));

      widget.selected[index] = widget.ticketTypes[0]; // Initialize to 0
    });
  }

  void _submit() {
    print('Ticket Types: ${widget.selected.values}');
    widget.onSubmit(context, widget.selected.values.toList());
  }
}
