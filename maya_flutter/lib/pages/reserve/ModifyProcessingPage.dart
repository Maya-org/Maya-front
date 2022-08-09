import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../../api/APIResponse.dart';
import '../../api/models/Models.dart';
import '../../component/reserve/ModifyProcessingPageView.dart';

class ModifyProcessingPage extends StatelessWidget {
  const ModifyProcessingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tuple3<Future<APIResponse<bool?>>, Reservation,Group> tuple =
    ModalRoute.of(context)!.settings.arguments
    as Tuple3<Future<APIResponse<bool?>>, Reservation,Group>;
    return ModifyProcessingPageView(future: tuple.item1, reservation: tuple.item2,toUpdate: tuple.item3);
  }
}
