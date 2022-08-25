import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../ui/DefaultAppBar.dart';

class QRReader extends StatefulWidget {
  final Route<dynamic> Function(Barcode)? builder;
  final bool Function(Barcode) validator;
  final void Function(Barcode)? onNavigate;

  const QRReader({Key? key, this.builder, required this.validator, this.onNavigate})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRReaderState();
}

class _QRReaderState extends State<QRReader> {
  final MobileScannerController _controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('QRコード読み取り画面'),
      body: MobileScanner(
        allowDuplicates: false,
        controller: _controller,
        onDetect: (Barcode barcode, MobileScannerArguments? args) {
          if (barcode.rawValue != null && widget.validator(barcode)) {
            if (widget.builder != null) {
              _controller.stop();
              widget.onNavigate?.call(barcode);
              Navigator.of(context).pushReplacement(widget.builder!(barcode));
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
