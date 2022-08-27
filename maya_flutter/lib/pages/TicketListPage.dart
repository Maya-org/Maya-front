import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/models/Models.dart';
import '../component/ticket/TicketQRCode.dart';
import '../ui/DefaultAppBar.dart';

class TicketListPage extends StatefulWidget {
  final List<Ticket> tickets;
  final User user;

  const TicketListPage({Key? key, required this.tickets, required this.user}) : super(key: key);

  @override
  State<TicketListPage> createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  static const int scrollDuration = 500;
  int _index = -1;

  List<TicketQRCode>? _generated;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("チケット一斉表示"),
      body: Column(
        children: [
          Center(
            child: LayoutBuilder(
              builder: (ctx, con) {
                double min = con.maxWidth < con.maxHeight ? con.maxWidth : con.maxHeight;
                return SizedBox(
                  width: min,
                  height: min,
                  child: _index >= 0 ? _generated![_index] : Container(),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _start();
                  },
                  child: const Text("表示開始")),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _index = -1;
                    });
                  },
                  child: const Text("表示消去")),
            ],
          ),
          const SizedBox(height: 20),
          Center(child: Text(_index == -1 ? "未表示" : "${_index + 1} / ${widget.tickets.length}")),
        ],
      ),
    );
  }

  void _start() async {
    _generate();
    _next(-1, widget.tickets.length - 1);
  }

  void _generate() {
    _generated =
        widget.tickets.map((ticket) => TicketQRCode(ticket: ticket, user: widget.user)).toList();
  }

  void _next(int now, int max) {
    setState(() {
      _index = now + 1;
    });
    if (max == now + 1) return;
    Future.delayed(const Duration(milliseconds: scrollDuration), () {
      _next(now + 1, max);
    });
  }
}
