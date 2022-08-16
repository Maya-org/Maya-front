import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQRCode extends StatefulWidget {
  final User user;
  final Reservation reservation;

  const TicketQRCode({super.key, required this.user, required this.reservation});

  @override
  State<TicketQRCode> createState() => _TicketQRCodeState();
}

class _TicketQRCodeState extends State<TicketQRCode> {
  String? _qrCodeString;

  @override
  void initState() {
    super.initState();
    generateQRCodeData(widget.user, widget.reservation).then((value) {
      setState(() {
        _qrCodeString = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: updateQR,
      child: _child(),
    );
  }

  Widget _child(){
    if(_qrCodeString != null) {
      return QrImage(data: _qrCodeString!, version: QrVersions.auto);
    } else {
      return Container();
    }
  }

  Future<void> updateQR() async {
    String str = await generateQRCodeData(widget.user, widget.reservation);
    setState((){
      _qrCodeString = str;
    });
  }
}

Future<String> generateQRCodeData(User user, Reservation reservation) async {
  String token = await user.getIdToken(true);
  print('showing qr code:$token#${reservation.reservation_id}');
  return "$token#${reservation.reservation_id}";
}
