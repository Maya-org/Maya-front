import 'package:flutter/material.dart';
import 'package:maya_flutter/pages/debugPage.dart';
import 'package:tuple/tuple.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const List<Tuple2<Widget, BottomNavigationBarItem>> _pages = [
    Tuple2(
        DebugPage(),
        BottomNavigationBarItem(
          icon: Icon(Icons.abc),
          activeIcon: Icon(Icons.abc, color: Colors.blue),
          label: 'Debug',
        )),
    Tuple2(
        DebugPage(),
        BottomNavigationBarItem(
          icon: Icon(Icons.abc),
          activeIcon: Icon(Icons.abc, color: Colors.blue),
          label: 'Debug',
        )),
    Tuple2(
        DebugPage(),
        BottomNavigationBarItem(
          icon: Icon(Icons.abc),
          activeIcon: Icon(Icons.abc, color: Colors.blue),
          label: 'Debug',
        )),
    Tuple2(
        DebugPage(),
        BottomNavigationBarItem(
          icon: Icon(Icons.abc),
          activeIcon: Icon(Icons.abc, color: Colors.blue),
          label: 'Debug',
        ))
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemBuilder: (ctx, index) {
          return _pages[index].item1;
        },
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _pages.map((e) => e.item2).toList(),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
