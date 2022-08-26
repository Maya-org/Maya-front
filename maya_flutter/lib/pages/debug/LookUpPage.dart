import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/api/API.dart';
import 'package:maya_flutter/component/QRReader.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tuple/tuple.dart';

import '../check/CheckPage.dart';
import 'LookUpProcessingPage.dart';

class LookUpNavigatePage extends StatelessWidget {
  const LookUpNavigatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LookUpPage()));
      },
      child: const Text("情報照会"),
    ));
  }
}

class LookUpPage extends StatefulWidget {
  const LookUpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LookUpPageState();
}

class _LookUpPageState extends State<LookUpPage> {
  @override
  Widget build(BuildContext context) {
    return QRReader(
      validator: (Barcode barcode) {
        return readFromBarcode(barcode) != null;
      },
      builder: (Barcode barcode) {
        Tuple2<String, String> tuple = readFromBarcode(barcode)!;
        return MaterialPageRoute(builder: (BuildContext context) {
          return LookUpProcessingPage(future: lookUp(tuple.item1, tuple.item2));
        });
      },
    );
  }
}
