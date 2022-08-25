import 'package:flutter/material.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/pages/MainPage.dart';
import 'package:maya_flutter/ui/StyledText.dart';

import '../../ui/DefaultAppBar.dart';
import '../ReservationPersonCount.dart';

class ReservePostPageView extends StatefulWidget {
  final ReserveRequest reserveReq;
  final ReservableEvent event;
  final bool isReserved;
  final String? displayString;

  const ReservePostPageView(
      {Key? key,
      required this.reserveReq,
      required this.isReserved,
      required this.event,
      this.displayString})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReservePostPageViewState();
}

class _ReservePostPageViewState extends State<ReservePostPageView> {
  @override
  Widget build(BuildContext context) {
    if (widget.isReserved) {
      return Scaffold(
        appBar: defaultAppBar('予約完了画面'),
        body: Column(
          children: [
            ReservationPersonCount.fromReservation(
              widget.reserveReq.tickets,
            ),
            StyledTextWidget.mdFromAsset("assets/onReserve.md"),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (ctx) => const MainPage()));
              },
              child: const Text('戻る'),
            )
          ],
        ),
      );
    }
    return Scaffold(
      appBar: defaultAppBar("予約完了"),
      body: Center(
        child: Text("""予約に失敗しました
エラー内容:
${widget.displayString}"""),
      ),
    );
  }

  Widget _genBody() {
    if (widget.isReserved) {
      return ReservationPersonCount.fromReservation(
        widget.reserveReq.tickets,
      );
    } else {
      return Text("""予約に失敗しました
エラー内容:
${widget.displayString}""");
    }
  }
}
