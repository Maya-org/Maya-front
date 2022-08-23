import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../ui/StyledText.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledTextWidget.mdFromAsset("assets/document.md");
  }
}
