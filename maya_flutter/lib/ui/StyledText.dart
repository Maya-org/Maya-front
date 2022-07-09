import 'package:flutter/widgets.dart';

class StyledTextWidget extends StatelessWidget {
  final Text text;

  const StyledTextWidget(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: text,
      ),
    ]);
  }
}