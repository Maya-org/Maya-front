import 'package:flutter/widgets.dart';

import '../../api/models/Models.dart';
import '../../component/reserve/CancelView.dart';

class CancelPage extends StatelessWidget {
  const CancelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Reservation reservation = ModalRoute.of(context)!.settings.arguments as Reservation;
    return CancelPageView(reservation: reservation);
  }
}
