import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maya_flutter/component/heatMap/HeatMap.dart';
import 'package:maya_flutter/pages/crowded/CrowdedListPage.dart';

class CrowdedPage extends StatefulWidget {
  const CrowdedPage({Key? key}) : super(key: key);

  @override
  State<CrowdedPage> createState() => _CrowdedPageState();
}

class _CrowdedPageState extends State<CrowdedPage> {
  late List<Widget> _choices;

  @override
  void initState(){
    super.initState();
    _choices = [
      ListTile(
        title: const Text('混雑状況一覧'),
        subtitle: const Text('各出展団体の混雑状況を表示します。'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const CrowdedListPage()));
        },
      ),
      ListTile(
        title: const Text('混雑ヒートマップ'),
        subtitle: const Text('各出展団体の混雑状況をヒートマップで表示します。'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const HeatMap()));
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
            itemBuilder: (ctx, index) => _choices[index], itemCount: _choices.length));
  }
}
