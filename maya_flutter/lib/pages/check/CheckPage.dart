import 'package:flutter/material.dart';
import 'package:maya_flutter/component/Check/CheckProcessingPage.dart';
import 'package:maya_flutter/component/QRReader.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tuple/tuple.dart';

import '../../api/API.dart';
import '../../api/models/Models.dart';

class CheckPage extends StatefulWidget {
  final Room selectedRoom;
  final Operation operation;

  const CheckPage({Key? key, required this.selectedRoom, required this.operation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: QRReader(
            validator: (Barcode barcode) {
              return _readFromBarcode(barcode) != null;
            },
            builder: (Barcode barcode) {
              Tuple2<String, String> data = _readFromBarcode(barcode)!;
              return MaterialPageRoute(builder: (BuildContext context) {
                return CheckProcessingPage(
                    future: check(
                      widget.operation,
                      data.item1,
                      widget.selectedRoom,
                      data.item2,
                    ),
                    room: widget.selectedRoom,
                    operation: widget.operation);
              });
            },
          ),
        )
      ],
    );
  }

  Tuple2<String, String>? _readFromBarcode(Barcode barcode) {
    String? data = barcode.rawValue;
    if (data == null) {
      return null;
    }
    List<String> split = data.split("#");
    return Tuple2(split[0], split[1]);
  }
}
