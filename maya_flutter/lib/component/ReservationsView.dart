import 'package:flutter/material.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/models/ReservationChangeNotifier.dart';
import 'package:provider/provider.dart';

import '../ui/card/ReservationCard.dart';

class ReservationsView extends StatefulWidget {
  const ReservationsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReservationsViewState();
}

class _ReservationsViewState extends State<ReservationsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("予約一覧"),
        Flexible(child: Consumer<ReservationChangeNotifier>(
          builder: (context, model, _) {
            List<Reservation>? reservations = model.reservation;
            if (reservations == null) {
              return const Center(
                  child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));
            } else {
              return ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  return ReservationCard(reservation: reservations[index]);
                },
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
              );
            }
          },
        )),
      ],
    );
  }
}