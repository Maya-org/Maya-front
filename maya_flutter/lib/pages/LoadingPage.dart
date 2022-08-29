import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/pages/MainPage.dart';
import 'package:provider/provider.dart';

import '../models/UserChangeNotifier.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool _isInited = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInited) {
        _isInited = true;
        if (Provider.of<UserChangeNotifier>(context, listen: false).user != null) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (ctx) => const MainPage()));
          return;
        }
        Provider.of<UserChangeNotifier>(context, listen: false).addListener(() {
          if (Provider.of<UserChangeNotifier>(context, listen: false).user != null) {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (ctx) => const MainPage()));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
