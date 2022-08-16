import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
  final GlobalKey qrkey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRコード読み取り画面'),
      ),
      body: QRView(
          key: qrkey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.green,
            borderRadius: 16,
            borderLength: 24,
            borderWidth: 8,
            // cutOutSize: scanArea,
          )),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      // Listen QR code scan result
      if (widget.validator(scanData)) {
        if (widget.builder != null) {
          controller.pauseCamera();
          widget.onNavigate?.call(scanData);
          Navigator.of(context).pushReplacement(widget.builder!(scanData));
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
