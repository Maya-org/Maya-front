import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../api/models/Models.dart';
import '../component/ReservePostPageView.dart';

class ReservePostPage extends StatelessWidget {
  const ReservePostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tuple3<ReserveRequest, ReservableEvent, bool> tuple3 =
        ModalRoute.of(context)!.settings.arguments as Tuple3<ReserveRequest, ReservableEvent, bool>;
    return ReservePostPageView(
        reserveReq: tuple3.item1, event: tuple3.item2, isReserved: tuple3.item3);
  }
}
