import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/component/QRReader.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TwoFactorPage extends StatefulWidget {
  final MaterialPageRoute Function(String code) builder;

  const TwoFactorPage({Key? key, required this.builder}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
  @override
  Widget build(BuildContext context) {
    return QRReader(builder: (Barcode barcode) {
      return widget.builder(barcode.rawValue!);
    }, validator: (Barcode barcode) {
      return barcode.rawValue != null;
    });
  }
}
