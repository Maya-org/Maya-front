import 'package:flutter/material.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/component/reserve/ModifyPageView.dart';

class ModifyPage extends StatelessWidget {
  const ModifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Reservation reservation = ModalRoute.of(context)!.settings.arguments as Reservation;
    return ModifyPageView(reservation: reservation);
  }
}
