import 'dart:math';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: defaultAppBar("チケット一斉表示"),
        body: TicketListPageBody(tickets: widget.tickets, user: widget.user));
  }
}

class TicketListPageBody extends StatefulWidget {
  final List<Ticket> tickets;
  final User user;

  const TicketListPageBody({super.key, required this.tickets, required this.user});

  @override
  State<StatefulWidget> createState() => _TicketListPageBodyState();
}

class _TicketListPageBodyState extends State<TicketListPageBody> {
  static const int scrollDuration = 500;
  final PageController _scrollController = PageController();
  List<TicketQRCode>? _generated;
  late Row _row;
  late PageView _pageView;

  _TicketListPageBodyState() {
    _row = Row(
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
                _generated = null;
              });
            },
            child: const Text("表示消去")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox.square(
          dimension: MediaQuery.of(context).size.minPixel(),
          child: _generated != null ? _pageView : Container(),
        ),
        _row,
        const SizedBox(height: 20),
        Center(child: Text("${widget.tickets.length}枚")),
      ],
    );
  }

  void _start() async {
    setState(() {
      _generated = widget.tickets
          .map((ticket) => TicketQRCode(ticket: ticket, uid: widget.user.uid))
          .toList();
      _pageView = PageView.builder(
        itemBuilder: (ctx, index) {
          return _generated![index];
        },
        itemCount: _generated!.length,
        controller: _scrollController,
      );
    });
    _next(-1, widget.tickets.length - 1);
  }

  void _next(int now, int max) {
    if (_scrollController.hasClients) {
      _scrollController.jumpToPage(now + 1);
      setState(() {});
    }
    if (max == now + 1) return;
    Future.delayed(const Duration(milliseconds: scrollDuration), () {
      _next(now + 1, max);
    });
  }
}

extension SizeExtension on Size {
  double minPixel() {
    return min(width, height);
  }
}
