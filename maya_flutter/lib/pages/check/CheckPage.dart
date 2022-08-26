import 'package:flutter/material.dart';
import 'package:maya_flutter/component/QRReader.dart';
import 'package:maya_flutter/ui/DefaultAppBar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tuple/tuple.dart';

import '../../api/API.dart';
import '../../api/APIResponse.dart';
import '../../api/models/Models.dart';
import '../../ui/APIResponseHandler.dart';

class CheckPage extends StatefulWidget {
  final Room selectedRoom;
  final Operation operation;

  const CheckPage({Key? key, required this.selectedRoom, required this.operation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  final List<CheckEntry> _results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
          "${widget.selectedRoom.display_name}${widget.operation.operationDisplayName}"),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        QRReader qrReader = QRReader(
          validator: (Barcode barcode) {
            return readFromBarcode(barcode) != null;
          },
          onValidData: (Barcode barcode) {
            Tuple2<String, String> data = readFromBarcode(barcode)!;
            setState(() {
              _results.add(CheckEntry.now(
                  widget.operation,
                  widget.selectedRoom,
                  check(
                    widget.operation,
                    data.item1,
                    widget.selectedRoom,
                    data.item2,
                  )));
            });
          },
        );

        if (constraints.maxWidth > constraints.maxHeight) {
          // 横長
          return Row(
            children: [
              RotatedBox(
                  quarterTurns: 3,
                  child: SizedBox(
                      width: constraints.maxHeight,
                      height: constraints.maxHeight,
                      child: qrReader)),
              Expanded(child: CheckResultWidget(checkResults: _results)),
            ],
          );
        } else {
          // 縦長
          return Column(
            children: [
              SizedBox(width: constraints.maxWidth, height: constraints.maxWidth, child: qrReader),
              Expanded(child: CheckResultWidget(checkResults: _results))
            ],
          );
        }
      }),
    );
  }
}

Tuple2<String, String>? readFromBarcode(Barcode barcode) {
  String? data = barcode.rawValue;
  if (data == null) {
    return null;
  }
  List<String> split = data.split("#");
  if (split.length != 2) {
    return null;
  }
  return Tuple2(split[0], split[1]);
}

class CheckResultWidget extends StatefulWidget {
  final List<CheckEntry> checkResults;

  const CheckResultWidget({Key? key, required this.checkResults}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckResultWidgetState();
}

class _CheckResultWidgetState extends State<CheckResultWidget> {
  @override
  Widget build(BuildContext context) {
    SingleChildScrollView w = SingleChildScrollView(
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return CheckResultItem(checkResult: widget.checkResults[index]);
            },
            itemCount: widget.checkResults.length,
            shrinkWrap: true,
            reverse: true));
    return w;
  }
}

class CheckResultItem extends StatefulWidget {
  final CheckEntry checkResult;

  const CheckResultItem({Key? key, required this.checkResult}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckResultItemState();
}

class _CheckResultItemState extends State<CheckResultItem> {
  @override
  void initState() {
    super.initState();
    widget.checkResult.listen((status) {
      setState(() {
        // redraw
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          "${widget.checkResult.toRoom.display_name}${widget.checkResult.operation.operationDisplayName}"),
      subtitle: Text(widget.checkResult.time.toStringWithSec()),
      trailing: widget.checkResult.status.icon,
    );
  }
}

class CheckEntry {
  Operation operation;
  Room toRoom;
  TimeStamp time;
  Future<APIResponse<bool?>> future;
  CheckStatus status = CheckStatus.pending;

  List<void Function(CheckStatus status)> _onStatusChanged = [];

  CheckEntry(
      {required this.operation, required this.toRoom, required this.time, required this.future}) {
    future.then((APIResponse<bool?> response) {
      handle(response, (p) {
        status = CheckStatus.completed;
      }, (r, e) {
        status = CheckStatus.failed;
      });

      for (var f in _onStatusChanged) {
        f(status);
      }
    });
  }

  factory CheckEntry.now(Operation operation, Room toRoom, Future<APIResponse<bool?>> future) {
    return CheckEntry(operation: operation, toRoom: toRoom, time: TimeStamp.now(), future: future);
  }

  void listen(void Function(CheckStatus status) f) {
    _onStatusChanged.add(f);
  }
}

enum CheckStatus {
  pending(Icon(Icons.hourglass_empty)),
  completed(Icon(
    Icons.check_circle_outline,
    color: Colors.green,
  )),
  failed(Icon(
    Icons.error_outline,
    color: Colors.red,
  ));

  final Icon icon;

  const CheckStatus(this.icon);
}
