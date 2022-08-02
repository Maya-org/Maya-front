import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQRCode extends StatelessWidget {
  final User user;
  final Reservation reservation;

  const TicketQRCode({super.key, required this.user, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return QrImage(data: generateQRCodeData(user, reservation), version: QrVersions.auto);
  }
}

String generateQRCodeData(User user, Reservation reservation) {
  return "${user.uid}-${reservation.reservation_id}";
}
