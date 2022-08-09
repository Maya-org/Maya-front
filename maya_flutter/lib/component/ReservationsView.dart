import 'package:flutter/material.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/api/APIResponse.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/ui/APIResponseHandler.dart';

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
        ElevatedButton(onPressed: (){setState((){});}, child: const Text("強制更新(Debug)")),
        Flexible(
          child: FutureBuilder<APIResponse<List<Reservation>?>>(
            future: _getReservations(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return handle<List<Reservation>, Widget>(snapshot.data!, (r) {
                  return ListView.builder(
                    itemCount: r.length,
                    itemBuilder: (context, index) {
                      return ReservationCard(reservation: r[index]);
                    },
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                  );
                }, (res, displayString) {
                  return const Text("error");
                });
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return const Center(child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));
              }
            },
          ),
        ),
      ],
    );
  }
}

APIResponse<List<Reservation>?>? _cache;

Future<APIResponse<List<Reservation>?>> _getReservations() async {
  if (_cache != null) {
    return _cache!;
  }
  APIResponse<List<Reservation>?> data = await getReserve();
  _cache = data;
  return data;
}

Future<void> updateReservations() async {
  _cache = null;
  await _getReservations();
}
