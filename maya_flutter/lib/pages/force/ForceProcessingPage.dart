import 'package:flutter/material.dart';
import 'package:maya_flutter/ui/APIResponseHandler.dart';
import 'package:maya_flutter/ui/DefaultAppBar.dart';

import '../../api/APIResponse.dart';
import '../../api/models/Models.dart';
import '../MainPage.dart';
import 'ForcePostPage.dart';

class ForceProcessingPage extends StatefulWidget {
  final Future<APIResponse<List<Ticket>?>> future;
  final ReserveRequest req;
  final ReservableEvent event;

  const ForceProcessingPage(
      {Key? key, required this.future, required this.req, required this.event})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForceProcessingPageState();
}

class _ForceProcessingPageState extends State<ForceProcessingPage> {
  @override
  void initState() {
    super.initState();
    widget.future.then((value) {
      if (!mounted) return;
      handle(
          value,
          (List<Ticket> p0) => {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (ctx) => const MainPage())),
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => ForcePostPage(data: p0, isSuccess: true))),
              },
          (p0, p1) => {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (ctx) => const MainPage())),
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ForcePostPage(data: null, isSuccess: false, message: p1))),
              });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("強制発券処理中"),
      body: const Center(
        child: Text("只今強制的に予約を処理中です..."),
      ),
    );
  }
}
