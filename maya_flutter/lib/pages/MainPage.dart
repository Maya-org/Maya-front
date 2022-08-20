import 'package:flutter/material.dart';
import 'package:maya_flutter/pages/HomePage.dart';
import 'package:maya_flutter/pages/check/CheckSelectPage.dart';
import 'package:tuple/tuple.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const List<Tuple2<Widget, BottomNavigationBarItem>> _pages = [
    Tuple2(
        HomePage(),
        BottomNavigationBarItem(
          icon: Icon(Icons.abc),
          activeIcon: Icon(Icons.abc, color: Colors.blue),
          label: 'Home',
        )),
    Tuple2(
        CheckSelectPage(),
        BottomNavigationBarItem(
          icon: Icon(Icons.abc),
          activeIcon: Icon(Icons.abc, color: Colors.blue),
          label: 'Check',
        )),
  ];
  int _currentIndex = 0;
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          itemBuilder: (ctx, index) {
            return _pages[index].item1;
          },
          itemCount: _pages.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          controller: _controller,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _pages.map((e) => e.item2).toList(),
        currentIndex: _currentIndex,
        onTap: (index) {
          _moveTo(index);
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  void _moveTo(int page) {
    setState(() {
      _currentIndex = page;
    });
    _controller.animateToPage(page, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }
}