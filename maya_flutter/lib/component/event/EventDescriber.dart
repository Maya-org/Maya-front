import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/models/Models.dart';

class EventDescriber extends StatelessWidget {
  final ReservableEvent event;
  final bool? toDescribeMore;

  const EventDescriber({Key? key, required this.event, this.toDescribeMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Text(event.display_name)),
        const SizedBox(height: 10),
        const Text("イベント開催時刻"),
        Text(_genTimeString()),
        if (event.description != null) ...[
          const SizedBox(height: 10),
          const Text("イベント概要"),
          Text(event.description!),
        ],
        if (_isLimitedReserveable()) ...[
          const SizedBox(height: 10),
          const Text("予約受付期間"),
          Text(_genLimitedTimeString()),
        ],
        if (event.require_two_factor && (toDescribeMore ?? true)) ...[
          const SizedBox(height: 10),
          const Text(
            "このイベントの予約には別紙に記載されている「申し込み用QRコード」が必要です",
            style: TextStyle(color: Colors.redAccent),
          ),
        ],
        if (event.required_reservation != null && (toDescribeMore ?? true)) ...[
          const SizedBox(height: 10),
          Text(
            "このイベントの予約には「${event.required_reservation!.display_name}」の予約が必要です。",
            style: const TextStyle(color: Colors.redAccent),
          ),
        ],
        if (event.available_at != null &&
            event.available_at!.toDateTime().isAfter(DateTime.now()) &&
            (toDescribeMore ?? true)) ...[
          const SizedBox(height: 10),
          Text(
            "このイベントは${event.available_at!.toStringWithSec()}までは予約できません。",
            style: const TextStyle(color: Colors.redAccent),
          ),
        ],
        if (event.closed_at != null &&
            event.closed_at!.toDateTime().isBefore(DateTime.now()) &&
            (toDescribeMore ?? true)) ...[
          const SizedBox(height: 10),
          Text(
            "このイベントは${event.closed_at!.toStringWithSec()}に受付を終了しました。",
            style: const TextStyle(color: Colors.redAccent),
          )
        ],
        if (event.not_co_exist_reservation != null && (toDescribeMore ?? true)) ...[
          const SizedBox(height: 10),
          Text(
            "このイベントの予約と「${event.not_co_exist_reservation!.display_name}」の予約は同時にできません。",
            style: const TextStyle(color: Colors.redAccent),
          ),
        ],
      ],
    );
  }

  String _genTimeString() {
    return "${event.date_start.toStringWithMin()} ~ ${event.date_end?.toStringWithMin() ?? "未定"}";
  }

  bool _isLimitedReserveable() {
    return event.available_at != null || event.closed_at != null;
  }

  String _genLimitedTimeString() {
    return "${event.available_at?.toStringWithMin() ?? ""} ~ ${event.closed_at?.toStringWithMin() ?? ""}";
  }
}
