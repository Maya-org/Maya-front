import 'package:flutter/material.dart';

class PageControllerVisualizer extends StatefulWidget {
  final PageController _pageController;
  final int pageCount;

  const PageControllerVisualizer(this._pageController, this.pageCount, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageControllerVisualizerState();
}

class _PageControllerVisualizerState extends State<PageControllerVisualizer> {
  double _page = 0;

  @override
  void initState() {
    super.initState();
    widget._pageController.addListener(() {
      setState(() {
        _page = widget._pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    widget._pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
              flex: 1,
              child: InkWell(
                onTap: _left,
                child: const Center(child: Icon(Icons.chevron_left)),
              )),
          Flexible(flex: 6, child: Center(child: Text("${_page.toInt() + 1}/${widget.pageCount}"))),
          Flexible(
              flex: 1,
              child: InkWell(
                onTap: _right,
                child: const Center(child: Icon(Icons.chevron_right)),
              )),
        ],
      ),
    );
  }

  void _left() {
    widget._pageController
        .previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _right() {
    widget._pageController
        .nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
}
