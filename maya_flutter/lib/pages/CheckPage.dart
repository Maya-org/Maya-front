import 'package:flutter/material.dart';
import 'package:maya_flutter/component/Check/CheckProcessingPage.dart';
import 'package:maya_flutter/component/QRReader.dart';
import 'package:maya_flutter/models/RoomsProvider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tuple/tuple.dart';

import '../api/API.dart';
import '../api/models/Models.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  List<Room>? _rooms;
  int _selectedRoomIndex = 0;
  Operation _operation = Operation.Enter;

  @override
  Widget build(BuildContext context) {
    _rooms = Provider.of<RoomsProvider>(context).list;

    List<DropdownMenuItem<int>> items = [];
    if (_rooms != null) {
      items = _rooms!.map((e) {
        return DropdownMenuItem<int>(
          value: _rooms!.indexOf(e),
          child: Text(e.display_name),
        );
      }).toList();
    }

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
                  _operation,
                  data.item1,
                  _selectedRoom(),
                  data.item2,
                ));
              });
            },
          ),
        ),
        SizedBox(
          height: 100,
          child: Row(
            children: [
              DropdownButton<int>(
                items: items,
                value: _selectedRoomIndex,
                onChanged: (int? index) {
                  setState(() {
                    _selectedRoomIndex = index!;
                  });
                },
              ),
              DropdownButton<Operation>(
                items:Operation.values.map((e) {
                  return DropdownMenuItem<Operation>(
                    value: e,
                    child: Text(e.operationDisplayName),
                  );
                }).toList(),
                value:_operation,
                onChanged: (Operation? op) {
                  setState(() {
                    _operation = op!;
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Room _selectedRoom() {
    return _rooms![_selectedRoomIndex]; // TODO 謎Nullぽ
  }

  Tuple2<String, String>? _readFromBarcode(Barcode barcode) {
    String? data = barcode.code;
    if (data == null) {
      return null;
    }
    List<String> split = data.split("#");
    return Tuple2(split[0], split[1]);
  }
}
