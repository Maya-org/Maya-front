import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/models/Models.dart';

class EventDescriber extends StatelessWidget {
  final ReservableEvent event;
  const EventDescriber({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child:Text(event.display_name)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text("開始時刻"),
                  Text(event.date_start.toString()),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Text("終了時刻"),
                  Text(event.date_end?.toString() ?? "未定"),
                ],
              ),
            ),
          ],
        ),
        if(event.description != null) ...[
          const SizedBox(height: 10),
          const Text("イベント概要"),
          const SizedBox(height: 10),
          Text(event.description!),
        ],
        if(event.require_two_factor) ...[
          const SizedBox(height: 10),
          const Text("このイベントの予約には別紙に記載されている「申し込み用QRコード」が必要です",style: TextStyle(color: Colors.redAccent),),
        ],
        if(event.required_reservation != null) ...[
          const SizedBox(height: 10),
          Text("このイベントの予約には「${event.required_reservation!.display_name}」の予約が必要です。",style: const TextStyle(color: Colors.redAccent),),
        ],
        if(event.available_at != null && event.available_at!.toDateTime().isAfter(DateTime.now())) ...[
          const SizedBox(height: 10),
          Text("このイベントは${event.available_at!.toString()}までは予約できません。",style: const TextStyle(color: Colors.redAccent),),
        ],
      ],
    );
  }
}
