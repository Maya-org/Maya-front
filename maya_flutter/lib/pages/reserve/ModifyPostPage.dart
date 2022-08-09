import 'package:flutter/widgets.dart';
import 'package:maya_flutter/component/reserve/ModifyPostPageView.dart';
import 'package:tuple/tuple.dart';

import '../../api/models/Models.dart';

class ModifyPostPage extends StatelessWidget {
  const ModifyPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tuple4<Reservation, Group, bool, String?> tuple4 =
        ModalRoute.of(context)!.settings.arguments as Tuple4<Reservation, Group, bool, String?>;
    return ModifyPostPageView(
        isReserved: tuple4.item3,
        beforeReservation: tuple4.item1,
        toUpdate: tuple4.item2,
        displayString: tuple4.item4);
  }
}
