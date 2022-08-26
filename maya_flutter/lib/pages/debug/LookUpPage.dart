import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/component/QRReader.dart';
import 'package:maya_flutter/ui/DefaultAppBar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tuple/tuple.dart';

import '../check/CheckPage.dart';
import 'LookUpProcessingPage.dart';

class LookUpPage extends StatefulWidget {
  const LookUpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LookUpPageState();
}

class _LookUpPageState extends State<LookUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: defaultAppBar("情報照会ページ"),
        body: QRReader(
          validator: (Barcode barcode) {
            return readFromBarcode(barcode) != null;
          },
          builder: (Barcode barcode) {
            Tuple2<String,String> tuple = readFromBarcode(barcode)!;
            return MaterialPageRoute(builder: (BuildContext context) {
              return LookUpProcessingPage(future:lookUp(tuple.item1, tuple.item2));
            });
          },
        ));
  }
}
