import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/firebase_options.dart';
import 'package:maya_flutter/messages.i18n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MayaApp());
}

class MayaApp extends StatelessWidget {
  const MayaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: const Messages().app_title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TitlePage(title: const Messages().page_title),
    );
  }
}

class TitlePage extends StatefulWidget {
  const TitlePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
