import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../api/models/Models.dart';
import '../../ui/UI.dart';

class TicketTypeSelector extends StatefulWidget {
  final List<TicketType> ticketTypes;
  final void Function(BuildContext, TicketType, Group) onSelect;

  const TicketTypeSelector({Key? key, required this.ticketTypes, required this.onSelect})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TicketTypeSelectorState();
}

class _TicketTypeSelectorState extends State<TicketTypeSelector> {
  int _selectedTicketIndex = 0;
  int _selectedGroupIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text("チケット種別"),
        DropdownButton<int>(
          value: _selectedTicketIndex,
          items: widget.ticketTypes.map((TicketType ticketType) {
            return DropdownMenuItem<int>(
              value: widget.ticketTypes.indexOf(ticketType),
              child: Text(ticketType.display_ticket_name),
            );
          }).toList(),
          onChanged: (int? index) {
            setState(() {
              _selectedTicketIndex = index!;
              _selectedGroupIndex = 0;
            });
          },
        ),
        DropdownButton<int>(
          value: _selectedGroupIndex,
          items: widget.ticketTypes[_selectedTicketIndex].reservable_group.map((Group group) {
            return DropdownMenuItem<int>(
              value: widget.ticketTypes[_selectedTicketIndex].reservable_group.indexOf(group),
              child: Text(group.prettyPrint()),
            );
          }).toList(),
          onChanged: (int? index) {
            setState(() {
              _selectedGroupIndex = index!;
            });
          },
        ),
        ElevatedButton(
            onPressed: () {
              showOKDialog(context,
                  title: const Text("予約しますか?"),
                  body: Text(
                      """チケットタイプ:${widget.ticketTypes[_selectedTicketIndex].display_ticket_name}を予約しますか?"""),
                  onOK: () {
                widget.onSelect(context, widget.ticketTypes[_selectedTicketIndex],
                    widget.ticketTypes[_selectedTicketIndex].reservable_group[_selectedGroupIndex]);
              }, toClose: false);
            },
            child: const Text("決定"))
      ],
    );
  }
}
