import 'package:flutter/material.dart';
import 'package:maya_flutter/models/ReservationChangeNotifier.dart';
import 'package:maya_flutter/ui/card/UICard.dart';
import 'package:provider/provider.dart';

import '../../api/models/Models.dart';
import 'EventDescriber.dart';

class EventView extends StatefulWidget {
  final ReservableEvent event;

  const EventView({Key? key, required this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    // Future which fires at event.available_at.
    if (widget.event.available_at != null) {
      Future.delayed(widget.event.available_at!.toDateTime().difference(DateTime.now()), () {
        if (!_isDisposed) {
          setState(() {}); // 予約可能時間になったら予約ボタンを解放する用
        }
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true; // キャンセルしておく
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ReservableEvent event = widget.event;
    return Scaffold(
      appBar: AppBar(
        title: Text(event.display_name),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                UICard(
                    toExpandTop: false,
                    // top: ImageLoader.loadFromAsset(event.event_id),
                    title: Text(event.display_name),
                    body: EventDescriber(event: event)),
                Consumer<ReservationChangeNotifier>(
                    builder: (ctx, reservations, child) {
                      checkReserved(reservations.reservation ?? []);
                      return ElevatedButton(
                          onPressed: _isReservable()
                              ? () {
                                  _reserveEvent(event);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 100.0, vertical: 5.0)),
                          child: child);
                    },
                    child: const Text("このイベントを予約する"))
              ]),
            )),
      ),
    );
  }

  void _reserveEvent(ReservableEvent event) {
    Navigator.of(context).pushNamed("/reserve", arguments: event);
  }

  void checkReserved(List<Reservation> reservations) {
    if (widget.event.required_reservation == null) {
      _isReservedRequiredEvent = true;
      return;
    }
    _isReservedRequiredEvent = false;
    for (var reservation in reservations) {
      if (reservation.event.event_id == widget.event.required_reservation!.event_id) {
        _isReservedRequiredEvent = true;
        return;
      }
    }
  }

  bool _isReservedRequiredEvent = false;

  bool _isReservable() {
    bool b = true;
    if (widget.event.available_at != null) {
      b = b && widget.event.available_at!.toDateTime().isBefore(DateTime.now());
    }
    if (widget.event.required_reservation != null) {
      b = b && _isReservedRequiredEvent;
    }
    return b;
  }
}
