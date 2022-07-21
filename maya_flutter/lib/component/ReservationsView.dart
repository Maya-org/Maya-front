import 'package:flutter/material.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/api/APIResponse.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/ui/APIResponseHandler.dart';

import '../ui/ReservationCard.dart';

class ReservationsView extends StatefulWidget {
  const ReservationsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReservationsViewState();
}

class _ReservationsViewState extends State<ReservationsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("予約一覧"),
        FutureBuilder<APIResponse<List<Reservation>?>>(
          future: getReserve(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return handle<List<Reservation>, Widget>(snapshot.data!, (r) {
                return ListView.builder(
                  itemCount: r.length,
                  itemBuilder: (context, index) {
                    return ReservationCard(reservation: r[index]);
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                );
              }, (res, displayString) {
                return const Text("error");
              });
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const SizedBox(height: 50, width: 50, child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}
