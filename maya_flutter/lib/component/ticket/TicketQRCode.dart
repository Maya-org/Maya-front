import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQRCode extends StatefulWidget {
  final User user;
  final Ticket ticket;
  late String? _qrCodeString;
  late QrImage? _cached;
  late QrCode? _cachedQrCode;

  TicketQRCode({super.key, required this.user, required this.ticket}){
    _doCache();
  }

  @override
  State<TicketQRCode> createState() => _TicketQRCodeState();

  void _doCache() {
    _qrCodeString = generateQRCodeData(user, ticket);
    _cachedQrCode = QrCode.fromData(data: _qrCodeString!, errorCorrectLevel: QrErrorCorrectLevel.L);
    _cachedQrCode!.make();
    _cached = QrImage.withQr(qr: _cachedQrCode!, version: QrVersions.auto);
  }
}

class _TicketQRCodeState extends State<TicketQRCode> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: updateQR,
      child: widget._cached,
    );
  }

  void updateQR() {
    widget._doCache();
    setState(() {});
  }
}

String generateQRCodeData(User user, Ticket ticket) {
  return "${user.uid}#${ticket.ticket_id}";
}
