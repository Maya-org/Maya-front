import 'package:flutter/material.dart';

AppBar defaultAppBar(String title) {
  return AppBar(
    foregroundColor: Colors.black,
    elevation: 0,
    backgroundColor: Colors.white,
    title: Text(title),
    titleTextStyle: const TextStyle(
      color: Colors.black,
    ),
  );
}
