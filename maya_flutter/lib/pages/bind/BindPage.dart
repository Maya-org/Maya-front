import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/component/QRReader.dart';
import 'package:maya_flutter/ui/UI.dart';
import 'package:maya_flutter/util/CollectionUtils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tuple/tuple.dart';

import '../../api/APIResponse.dart';
import '../../ui/APIResponseHandler.dart';
import '../../ui/DefaultAppBar.dart';
import '../check/CheckPage.dart';

class BindPage extends StatefulWidget {
  const BindPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BindPageState();
}

class _BindPageState extends State<BindPage> {
  List<ScannedBindEntry> _pool = [];
  List<ScannedBindEntry> _results = [];
  List<Tuple2<String, String>> _tickets = [];
  List<String> _wristBands = [];
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    QRReader reader = QRReader(
        validator: (barcode) => barcode.rawValue != null && barcode.rawValue!.isNotEmpty,
        onValidData: _handleBarcode);

    return Scaffold(
      appBar: defaultAppBar("リストバンド紐づけ"),
      body: SizedBox.expand(
        child: LayoutBuilder(builder: (BuildContext ctx, BoxConstraints constraints) {
          if (constraints.maxWidth > constraints.maxHeight) {
            return Row(children: [
              SizedBox(width: constraints.maxHeight, height: constraints.maxHeight, child: reader),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  SizedBox(width: double.maxFinite, child: _buildIndicator()),
                  Expanded(child: _buildResultList())
                ]),
              )
            ]);
          } else {
            return Column(children: [
              SizedBox(width: constraints.maxWidth, height: constraints.maxWidth, child: reader),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(width: double.maxFinite, child: _buildIndicator()),
                    Expanded(child: _buildResultList()),
                  ],
                ),
              ),
            ]);
          }
        }),
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("チケット:${_tickets.length}"),
        Text("リストバンド:${_wristBands.length}"),
        ElevatedButton(
            onPressed: () {
              clear();
            },
            child: const Text("リセット"))
      ],
    );
  }

  Widget _buildResultList() {
    List<ScannedBindEntry> scanned = [];
    scanned.addAll(_results);
    scanned.addAll(_pool);
    return ListView.builder(
        itemCount: scanned.length,
        itemBuilder: (BuildContext context, int index) {
          return scanned[index];
        });
  }

  void _handleBarcode(Barcode barcode) {
    if (barcode.rawValue == null) {
      return;
    }
    Tuple2<String, String>? data = readFromBarcode(barcode);
    if (data == null) {
      // リストバンド読み取りだと信じる
      if (_wristBands.contains(barcode.rawValue!)) {
        return;
      }
      _wristBands.add(barcode.rawValue!);
      showSnackBar("リストバンドを読み取りました");
    } else {
      // チケット読み取りだと信じる
      if (_tickets.contains(data)) {
        return;
      }
      _tickets.add(data);
      showSnackBar("チケットを読み取りました");
    }

    setState(() {});
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      _collect();
    });

    _bind();
  }

  /// 直近のbindをまとめる
  void _collect() {
    List<BindEntry> en = _pool.map((ScannedBindEntry e) => e.entries).toList().flatten();
    if (en.isEmpty) {
      return;
    }
    ScannedBindEntry entry = ScannedBindEntry(entries: en);
    _results.add(entry);
    _pool.clear();
    setState(() {});
  }

  // チケットとリストバンドの数がそれぞれ一つ以上あったらバインド処理を行う
  void _bind() {
    // チケットとリストバンドの数が足りていることを確認
    if (!(_tickets.isNotEmpty && _wristBands.isNotEmpty)) {
      return;
    }

    // チケットとリストバンドの数が一致しているのでバインド処理を行う
    List<BindEntry> entries = [];
    int count = min(_tickets.length, _wristBands.length);
    for (int i = 0; i < count; i++) {
      String wristBand = _wristBands[i];
      Tuple2<String, String> ticket = _tickets[i];
      BindEntry entry = _createBind(ticket.item1, ticket.item2, wristBand);
      entries.add(entry);
    }
    _pool.add(ScannedBindEntry(entries: entries));

    // チケットとリストバンドのデータをクリアする
    clear(until: count);

    setState(() {});
  }

  BindEntry _createBind(String reserverID, String ticketId, String wristBandId) {
    Future<APIResponse<bool?>> future = postBind(wristBandId, reserverID, ticketId);
    BindEntry entry = BindEntry(reserverID, ticketId, wristBandId, future, TimeStamp.now());
    return entry;
  }

  void showSnackBar(String data) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(data),
      backgroundColor: Colors.blue,
    ));
  }

  /// [until] までクリアする
  void clear({int? until}) {
    if (until == null) {
      _tickets.clear();
      _wristBands.clear();
    } else {
      _tickets.removeRange(0, until);
      _wristBands.removeRange(0, until);
    }
    setState(() {});
  }
}

class BindEntry {
  final String reserverId;
  final String ticketId;
  final String wristBandId;
  TimeStamp bindedAt;
  Future<APIResponse<bool?>> future;
  RequestStatus status = RequestStatus.pending;
  String? error;

  List<void Function(RequestStatus status)> _onStatusChanged = [];

  BindEntry(this.reserverId, this.ticketId, this.wristBandId, this.future, this.bindedAt) {
    future.then((APIResponse<bool?> response) {
      handle(response, (p) {
        status = RequestStatus.completed;
      }, (r, String e) {
        status = RequestStatus.failed;
        error = e;
      });

      for (var f in _onStatusChanged) {
        f(status);
      }
    });
  }

  void listen(void Function(RequestStatus status) f) {
    _onStatusChanged.add(f);
  }
}

class ScannedBindEntry extends StatefulWidget {
  final List<BindEntry> entries;

  const ScannedBindEntry({Key? key, required this.entries}) : super(key: key);

  @override
  State<ScannedBindEntry> createState() => _ScannedBindEntryState();
}

class _ScannedBindEntryState extends State<ScannedBindEntry> {
  RequestStatus _status = RequestStatus.pending;

  @override
  void initState() {
    super.initState();
    for (var entry in widget.entries) {
      entry.listen((status) {
        _checkStateUpdate();
      });
    }
  }

  void _checkStateUpdate() {
    if (_status == RequestStatus.completed || _status == RequestStatus.failed) {
      return;
    }
    if (widget.entries.all((entry) => entry.status == RequestStatus.completed)) {
      setState(() {
        _status = RequestStatus.completed;
      });
    } else if (widget.entries.any((element) => element.status == RequestStatus.failed)) {
      setState(() {
        _status = RequestStatus.failed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_buildTitle()),
      subtitle: Text(_getLatestTime().bindedAt.toStringWithSec()),
      trailing: InkWell(
        onTap: () {
          if (_status == RequestStatus.failed) {
            _showErrorDialog();
          }
        },
        child: _status.icon,
      ),
    );
  }

  String _buildTitle() {
    if (widget.entries.length == 1) {
      switch (_status) {
        case RequestStatus.pending:
          return "紐づけ処理中";
        case RequestStatus.completed:
          return "紐づけ処理成功";
        case RequestStatus.failed:
          return "紐づけ処理失敗";
      }
    } else {
      switch (_status) {
        case RequestStatus.pending:
          return "${widget.entries.length}件の紐づけ処理中";
        case RequestStatus.completed:
          return "${widget.entries.length}件の紐づけ処理成功";
        case RequestStatus.failed:
          return "${widget.entries.length}件の紐づけ処理失敗";
      }
    }
  }

  BindEntry _getLatestTime() {
    return widget.entries
        .maxByCompare((p0, p1) => p0.bindedAt.toDateTime().compareTo(p1.bindedAt.toDateTime()));
  }

  void _showErrorDialog() {
    showOKDialog(context,
        title: const Text("紐づけエラー"),
        body: Text("エラーメッセージ一覧:[${widget.entries.map((e) {
              return e.error;
            }).toList().filterNotNull().join(",")}]"));
  }
}
