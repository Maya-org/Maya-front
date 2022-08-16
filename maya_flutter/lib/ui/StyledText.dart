import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class StyledTextWidget extends StatelessWidget {
  final List<Text> text;

  StyledTextWidget.fromString(List<String> texts, {Key? key, bool? shrinkWrap})
      : this(texts.map((text) => Text(text)).toList(), key: key);

  StyledTextWidget.fromStringOne(String text, {Key? key, bool? shrinkWrap})
      : this.fromString(<String>[text], key: key, shrinkWrap: shrinkWrap);

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

  static Markdown mdFromString(String text,bool shrink) {
    return Markdown(data: text,shrinkWrap: shrink,selectable: true);
  }
}
