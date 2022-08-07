import 'package:flutter/material.dart';

import '../api/models/Models.dart';
import '../component/ReservePageView.dart';

class ReservePage extends StatelessWidget {
  const ReservePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReservableEvent event = ModalRoute.of(context)!.settings.arguments as ReservableEvent;
    return Scaffold(
        appBar: AppBar(
          title: Text("${event.display_name}の新規予約"),
        ),
        body: ReservePageView(event: event)
    );
  }
}
