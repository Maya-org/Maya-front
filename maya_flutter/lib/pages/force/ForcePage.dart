import 'package:flutter/material.dart';
import 'package:maya_flutter/models/EventChangeNotifier.dart';
import 'package:maya_flutter/pages/force/ForceTicketSelectPage.dart';
import 'package:provider/provider.dart';

import '../../api/models/Models.dart';

class ForcePage extends StatefulWidget {
  const ForcePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForcePageState();
}

class _ForcePageState extends State<ForcePage> {
  ReservableEvent? _selectedEvent;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("強制発券ページ"),
        Consumer<EventChangeNotifier>(builder: (ctx, notifier, child) {
          return DropdownButton<ReservableEvent>(
            items: notifier.events?.map((e) {
                  return DropdownMenuItem<ReservableEvent>(
                    value: e,
                    child: Text(e.display_name),
                  );
                }).toList() ??
                [],
            value: _selectedEvent,
            onChanged: (ReservableEvent? event) {
              setState(() {
                _selectedEvent = event;
              });
            },
          );
        }),
        TextField(
          decoration: InputDecoration(hintText: "備考を記入"),
          controller: _controller,
        ),
        ElevatedButton(
            onPressed: _selectedEvent == null
                ? null
                : () {
                    _post();
                  },
            child: const Text("発行する"))
      ],
    );
  }

  void _post() {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return ForceTicketSelectPage(
        event: _selectedEvent!,
        data: _controller.text,
      );
    }));
  }
}
