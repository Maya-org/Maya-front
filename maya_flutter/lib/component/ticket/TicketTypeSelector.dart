import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../api/models/Models.dart';

class TicketTypeSelector extends StatefulWidget {
  final List<TicketType> ticketTypes;
  final void Function(TicketType toChange) onChange;

  TicketTypeSelector({Key? key, required this.ticketTypes, required this.onChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TicketTypeSelectorState();
}

class _TicketTypeSelectorState extends State<TicketTypeSelector> {
  int _selectedTicketTypeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(items: widget.ticketTypes.map((e) =>
        DropdownMenuItem<int>(
            value: widget.ticketTypes.indexOf(e),
            child: Text(e.display_ticket_name)
        )).toList(),
      onChanged: (int? newValue) {
        setState(() {
          _selectedTicketTypeIndex = newValue!;
          widget.onChange(widget.ticketTypes[newValue]);
        });
      },
      value: _selectedTicketTypeIndex,
    );
  }
}
