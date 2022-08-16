import 'package:flutter/material.dart';

class FullScreenLoadingCircular extends StatefulWidget {
  FullScreenLoadingCircular({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FullScreenLoadingCircularState();
  }
}

class _FullScreenLoadingCircularState extends State<FullScreenLoadingCircular> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
