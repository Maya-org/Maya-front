import 'package:flutter/material.dart';
import 'package:maya_flutter/component/reserve/ReservePostPageView.dart';
import 'package:tuple/tuple.dart';

import '../../api/models/Models.dart';

class ReservePostPage extends StatelessWidget {
  const ReservePostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tuple4<ReserveRequest, ReservableEvent, bool,String?> tuple4 =
        ModalRoute.of(context)!.settings.arguments as Tuple4<ReserveRequest, ReservableEvent, bool,String?>;
    return ReservePostPageView(
        reserveReq: tuple4.item1, event: tuple4.item2, isReserved: tuple4.item3,displayString: tuple4.item4);
  }
}
