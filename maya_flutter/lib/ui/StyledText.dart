import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static Markdown mdFromString(String text, bool shrink,
      {bool selectable = true, bool navigateLink = true}) {
    return Markdown(
      data: text,
      shrinkWrap: shrink,
      selectable: selectable,
      onTapLink: (String text, String? href, String title) async {
        if (navigateLink && href != null) {
          try {
            Uri uri = Uri.parse(href);
            if (uri.scheme == 'http' || uri.scheme == 'https') {
              if(!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
              }
            }
          } catch (e) {
            // ignore
          }
        }
      },
    );
  }

  static Widget mdFromAsset(String src){
    return FutureBuilder(
        future: rootBundle.loadString(src),
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
