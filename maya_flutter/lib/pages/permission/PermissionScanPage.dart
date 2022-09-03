import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/ui/DefaultAppBar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../api/API.dart';
import '../../component/QRReader.dart';
import 'PermissionProgressPage.dart';

class PermissionScanPage extends StatefulWidget{
  final Map<String,bool> toGrant;

  const PermissionScanPage({Key? key, required this.toGrant}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PermissionScanPageState();
}

class _PermissionScanPageState extends State<PermissionScanPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar("権限付与読み取り画面"),
      body:QRReader(
        validator: (Barcode barcode) {
          return barcode.rawValue != null;
        },
        builder: (Barcode barcode) {
          return MaterialPageRoute(builder: (ctx){
            return PermissionProgressPage(
              future: postPermission(barcode.rawValue!, widget.toGrant),
            );
          });
        },
      )
    );
  }
}