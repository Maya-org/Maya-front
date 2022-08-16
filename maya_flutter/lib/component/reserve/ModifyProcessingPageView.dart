import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/ui/APIResponseHandler.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../api/APIResponse.dart';
import '../../api/models/Models.dart';
import '../../models/ReservationChangeNotifier.dart';

class ModifyProcessingPageView extends StatefulWidget {
  final Future<APIResponse<bool?>> future;
  final Reservation reservation;
  final Group toUpdate;

  const ModifyProcessingPageView(
      {Key? key, required this.future, required this.reservation, required this.toUpdate})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModifyProcessingPageViewState();
}

class _ModifyProcessingPageViewState extends State<ModifyProcessingPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("予約変更処理中"),
      ),
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
      Navigator.of(context).pushNamedAndRemoveUntil("/modify/post", ModalRoute.withName("/main"),
          arguments: Tuple4<Reservation, Group, bool, String?>(
              widget.reservation, widget.toUpdate, true, null));
    }, (response, displayString) {
      // 変更に失敗
      Navigator.of(context).pushNamedAndRemoveUntil("/modify/post", ModalRoute.withName("/main"),
          arguments: Tuple4<Reservation, Group, bool, String?>(
              widget.reservation, widget.toUpdate, false, displayString));
    });
  }
}
