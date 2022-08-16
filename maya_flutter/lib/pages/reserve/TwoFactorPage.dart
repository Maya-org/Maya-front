import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/component/QRReader.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../api/models/Models.dart';

class TwoFactorPage extends StatefulWidget {
  final ReservableEvent event;
  final Group toUpdate;
  final TicketType type;
  final MaterialPageRoute Function(String code) builder;

  const TwoFactorPage({Key? key, required this.event, required this.toUpdate, required this.type, required this.builder}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
  @override
  Widget build(BuildContext context) {
    return QRReader(builder: (Barcode barcode) {
      return widget.builder(barcode.code!);
    }, validator: (Barcode barcode) {
      return barcode.format == BarcodeFormat.qrcode && barcode.code != null;
    });
  }
}
