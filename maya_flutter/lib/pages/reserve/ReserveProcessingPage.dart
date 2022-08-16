import 'package:flutter/material.dart';
import 'package:maya_flutter/api/APIResponse.dart';
import 'package:maya_flutter/component/reserve/ReserveProcessingPageView.dart';
import 'package:tuple/tuple.dart';

import '../../api/models/Models.dart';

class ReserveProcessingPage extends StatelessWidget {
  const ReserveProcessingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tuple3<Future<APIResponse<String?>>, ReserveRequest, ReservableEvent> tuple =
        ModalRoute.of(context)!.settings.arguments
            as Tuple3<Future<APIResponse<String?>>, ReserveRequest, ReservableEvent>;
    return ReserveProcessingPageView(future: tuple.item1, req: tuple.item2, event: tuple.item3);
  }
}
