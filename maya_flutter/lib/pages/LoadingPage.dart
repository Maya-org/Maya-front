import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/UserChangeNotifier.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<UserChangeNotifier>(context, listen: false).addListener(() {
      if (Provider.of<UserChangeNotifier>(context, listen: false).user != null) {
        print('LoadingPage: user is not null');
        Navigator.pushReplacementNamed(context, "/main");
      }
    });

    return const SizedBox.expand(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
