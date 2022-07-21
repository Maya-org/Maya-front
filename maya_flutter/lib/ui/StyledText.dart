import 'package:flutter/widgets.dart';

class StyledTextWidget extends StatelessWidget {
  final List<Text> text;

  StyledTextWidget.one(Text text, {Key? key}) : this(<Text>[text], key: key);

  const StyledTextWidget(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: text,
        ),
      ),
    ]);
  }
}
