import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/component/reserve/ModifyPostPageView.dart';
import 'package:maya_flutter/ui/APIResponseHandler.dart';
import 'package:maya_flutter/ui/DefaultAppBar.dart';
import 'package:provider/provider.dart';

import '../../api/APIResponse.dart';
import '../../api/models/Models.dart';
import '../../models/ReservationChangeNotifier.dart';
import '../../pages/HomePage.dart';

class ModifyProcessingPageView extends StatefulWidget {
  final Future<APIResponse<bool?>> future;
  final Reservation fromReservation;
  final List<TicketType> toUpdate;

  const ModifyProcessingPageView(
      {Key? key, required this.future, required this.fromReservation, required this.toUpdate})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModifyProcessingPageViewState();
}

class _ModifyProcessingPageViewState extends State<ModifyProcessingPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("予約変更処理中"),
      body: Center(
        child: Column(
          children: const [
            Text("只今予約変更を処理中です..."),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.future.then((response) {
      // 応答があったので、ページを移動する
      _handlePostModify(response);
    });
  }

  void _handlePostModify(dynamic r) {
    r as APIResponse<bool?>;
    handle<bool, void>(r, (str) {
      // 変更に成功
      Provider.of<ReservationChangeNotifier>(context, listen: false).update(); // 予約データを更新
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
        return ModifyPostPageView(isReserved: true,beforeReservation: widget.fromReservation,toUpdate: widget.toUpdate,displayString: null);
      }));
    }, (response, displayString) {
      // 変更に失敗
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
        return ModifyPostPageView(isReserved: false,beforeReservation: widget.fromReservation,toUpdate: widget.toUpdate,displayString: displayString);
      }));
    });
  }
}
