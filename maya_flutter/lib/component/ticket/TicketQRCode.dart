import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQRCode extends StatefulWidget {
  final String? uid;
  final Ticket ticket;
  late String _qrCodeString;
  late QrImage _cached;
  late QrCode _cachedQrCode;

  TicketQRCode({super.key, required this.uid, required this.ticket}) {
    _doCache();
  }

  @override
  State<TicketQRCode> createState() => _TicketQRCodeState();

  void _doCache() {
    if (uid != null) {
      _qrCodeString = generateQRCodeData(uid!, ticket);
      _cachedQrCode =
          QrCode.fromData(data: _qrCodeString, errorCorrectLevel: QrErrorCorrectLevel.L);
      _cachedQrCode.make();
      _cached = QrImage.withQr(qr: _cachedQrCode, version: QrVersions.auto);
    }
  }
}

class _TicketQRCodeState extends State<TicketQRCode> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.uid != null) {
      return widget._cached;
    } else {
      return Container();
    }
  }

  void updateQR() {
    widget._doCache();
    setState(() {});
  }
}

String generateQRCodeData(String uid, Ticket ticket) {
  return "$uid#${ticket.ticket_id}";
}
