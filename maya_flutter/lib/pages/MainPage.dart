import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maya_flutter/models/PermissionsChangeNotifier.dart';
import 'package:maya_flutter/pages/DocumentPage.dart';
import 'package:maya_flutter/pages/HomePage.dart';
import 'package:maya_flutter/pages/check/CheckSelectPage.dart';
import 'package:maya_flutter/pages/debug/DebugPage.dart';
import 'package:maya_flutter/pages/debug/LookUpPage.dart';
import 'package:maya_flutter/pages/permission/PermissionPage.dart';
import 'package:maya_flutter/util/CollectionUtils.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'bind/BindNavigatePage.dart';
import 'crowded/CrowdedPage.dart';
import 'force/ForcePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final PageController _controller = PageController();
  List<Tuple2<Widget, BottomNavigationBarItem>> _pages = [];

  @override
  Widget build(BuildContext context) {
    _updatePages(Provider.of<PermissionsChangeNotifier>(context, listen: true).permissions);

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

  void _updatePages(List<String> permissions) {
    Tuple2<Widget, BottomNavigationBarItem>? currentPage = _pages.getOrNull(_currentIndex);
    List<Tuple2<Widget, BottomNavigationBarItem>> generated = Pages.generate(permissions);
    int newIndex = 0;
    if (currentPage != null) {
      newIndex = generated.indexOf(currentPage);
    }

    setState(() {
      _pages = generated;
      _currentIndex = newIndex;
    });
  }

  void _moveTo(int page) {
    _controller.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

    _handleDebugPage(page);
  }

  Timer? _resetDebugTapTimer;
  int _debugPageTapCount = 0;

  void _handleDebugPage(int page) {
    if (page == _pages.indexOf(Pages.documentPage.item1)) {
      _debugPageTapCount++;
      if (_debugPageTapCount == 4) {
        _debugPageTapCount = 0;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DebugPage()));
      }

      _resetDebugTapTimer?.cancel();
      _resetDebugTapTimer = Timer(const Duration(milliseconds: 300), () {
        _debugPageTapCount = 0;
      });
    }
  }
}

class Pages {
  static const reservePage = Tuple2(
      Tuple2(
          HomePage(),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            activeIcon: Icon(Icons.book, color: Colors.blue),
            label: '予約',
          )),
      <String>[]);

  static const checkPage = Tuple2(
      Tuple2(
          CheckSelectPage(),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            activeIcon: Icon(Icons.qr_code_scanner, color: Colors.blue),
            label: '入退場処理',
          )),
      ["entrance"]);

  static const heatMapPage = Tuple2(
      Tuple2(
          CrowdedPage(),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            activeIcon: Icon(Icons.map, color: Colors.blue),
            label: '混雑状況',
          )),
      <String>[]);

  static const documentPage = Tuple2(
      Tuple2(
          DocumentPage(),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            activeIcon: Icon(Icons.article, color: Colors.blue),
            label: '説明',
          )),
      <String>[]);

  static const lookUpPage = Tuple2(
      Tuple2(
          LookUpNavigatePage(),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search, color: Colors.blue),
            label: '情報照会',
          )),
      <String>["debug"]);

  static const permissionPage = Tuple2(
      Tuple2(
          PermissionPage(),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            activeIcon: Icon(Icons.settings, color: Colors.blue),
            label: '権限付与',
          )),
      <String>["promote"]);

  static const bindPage = Tuple2(
      Tuple2(
          BindNavigatePage(),
          BottomNavigationBarItem(
            icon: Icon(Icons.link),
            activeIcon: Icon(Icons.link, color: Colors.blue),
            label: '紐づけ',
          )),
      <String>["bind"]);

  static const forcePage = Tuple2(
      Tuple2(
          ForcePage(),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            activeIcon: Icon(Icons.warning, color: Colors.blue),
            label: '強制発券',
          )),
      <String>["force_reserve"]);

  static const pages = [
    reservePage,
    bindPage,
    checkPage,
    lookUpPage,
    heatMapPage,
    documentPage,
    permissionPage,
    forcePage
  ];

  static List<Tuple2<Widget, BottomNavigationBarItem>> generate(List<String> permissions) {
    return pages
        .where((element) => _isPermitted(element.item2, permissions))
        .map((element) => element.item1)
        .toList();
  }

  static bool _isPermitted(List<String> required, List<String> permissions) {
    if (required.isEmpty) return true;
    return required.every((element) => permissions.contains(element));
  }
}
