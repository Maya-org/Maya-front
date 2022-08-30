import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../component/heatMap/HeatMap.dart';

class HeatMapPage extends StatefulWidget {
  const HeatMapPage({Key? key}) : super(key: key);

  @override
  _HeatMapPageState createState() => _HeatMapPageState();
}

class _HeatMapPageState extends State<HeatMapPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Center(child: Text('HeatMapPage')),
        Expanded(child: SizedBox.expand(child: HeatMap()))
      ],
    );
  }
}