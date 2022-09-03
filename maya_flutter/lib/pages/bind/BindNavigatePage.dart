import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'BindPage.dart';

class BindNavigatePage extends StatefulWidget {
  const BindNavigatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BindNavigatePageState();
}

class _BindNavigatePageState extends State<BindNavigatePage> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text("リストバンド紐づけページ"),
      const SizedBox(height: 16),
      ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return const BindPage();
            }));
          },
          child: const Text("読み取り開始"))
    ]);
  }
}
