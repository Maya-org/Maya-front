import 'package:flutter/material.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/ui/card/EventCard.dart';

import '../api/APIResponse.dart';
import '../api/models/Models.dart';
import '../ui/APIResponseHandler.dart';

class EventsView extends StatefulWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("イベント一覧"),
        Expanded(
          child: FutureBuilder<APIResponse<List<ReservableEvent>?>>(
            future: _getEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return handle<List<ReservableEvent>, Widget>(snapshot.data!, (r) {
                  return ListView.builder(
                    itemCount: r.length,
                    itemBuilder: (context, index) {
                      return EventCard(r[index]);
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
                return const SizedBox(height: 50, width: 50, child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}

APIResponse<List<ReservableEvent>?>? _cache;

Future<APIResponse<List<ReservableEvent>?>> _getEvents() async {
  if (_cache != null) {
    return _cache!;
  }
  APIResponse<List<ReservableEvent>?> data = await event();
  _cache = data;
  return data;
}
