import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../api/models/Models.dart';
import 'TicketQRCode.dart';

class TicketElement extends StatefulWidget {
  final Ticket ticket;
  final User user;

  TicketElement({super.key, required this.ticket, required this.user});

  @override
  State<TicketElement> createState() => _TicketElementState();
}

class _TicketElementState extends State<TicketElement> {
  final GlobalKey _key = GlobalKey(debugLabel: "TicketElement");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          key: _key,
          child: Column(
            children: [
              TicketQRCode(ticket: widget.ticket, user: widget.user),
              Text(widget.ticket.ticket_type.display_ticket_name),
            ],
          ),
        ),
        Center(
            child: ElevatedButton(
          onPressed: _exportImage,
          child: const Text("画像として保存する"),
        )),
      ],
    );
  }

  void _exportImage() async {
    try {
      RenderRepaintBoundary boundary =
          _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image img = await boundary.toImage();
      ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        return;
      }
      // Uint8List pngBytes = byteData.buffer.as();
      // if (UniversalPlatform.isWeb) {
        // 強引にダウンロードします
        // final blob = html.Blob(byteData,'image/png');
        // final url = html.Url.createObjectUrlFromBlob(blob);
        // final anchor = html.document.createElement('a') as html.AnchorElement
        //   ..href = url
        //   ..style.display = 'none'
        //   ..download = 'QR.png';
        // html.document.body!.children.add(anchor);
        // download
        // anchor.click();
        // cleanup
        // html.document.body!.children.remove(anchor);
        // html.Url.revokeObjectUrl(url);
        // print('saved');
      // } else {
      //   String path =
      //       await FileSaver.instance.saveFile("QR", pngBytes, "png", mimeType: MimeType.PNG);
      //   print('Saved :"$path"');
      // }
    } catch (e) {
      return;
    }
  }
}
