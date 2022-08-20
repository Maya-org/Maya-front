import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

import '../ui/StyledText.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: rootBundle.loadString('assets/document.md'),
        builder: (ctx, snapShot) {
          if (snapShot.hasData) {
            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: StyledTextWidget.mdFromString(snapShot.data! as String, true,
                    selectable: false));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
