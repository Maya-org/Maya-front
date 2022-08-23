import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_saver/file_saver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:universal_platform/universal_platform.dart';

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
          child: const Text("画像として保存する(PCのみ)"),
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
      Uint8List pngBytes = byteData.buffer.asUint8List();
      if (UniversalPlatform.isWeb) {
        js.context.callMethod(
          "saveAsImage",
          [
            html.Blob([pngBytes]),
            'QR.png',
          ],
        );
        print('Saved on Web');
      } else {
        String path =
            await FileSaver.instance.saveFile("QR", pngBytes, "png", mimeType: MimeType.PNG);
        print('Saved :"$path"');
      }
    } catch (e) {
      return;
    }
  }
}
