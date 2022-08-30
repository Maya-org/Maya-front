import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as ui;
import 'package:maya_flutter/component/heatMap/PathUtil.dart';
import 'package:maya_flutter/models/HeatMapChangeNotifier.dart';
import 'package:maya_flutter/models/RoomsProvider.dart';
import 'package:maya_flutter/util/CollectionUtils.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../api/models/Models.dart';
import '../../ui/DefaultAppBar.dart';

class HeatMap extends StatefulWidget {
  const HeatMap({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('混雑ヒートマップ'),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: (constraints.maxWidth / widthScale.toDouble()) * heightScale.toDouble(),
              child: CustomPaint(
                painter: _HeatMapPainter(Provider.of<HeatMapChangeNotifier>(context).data,
                    Provider.of<RoomsProvider>(context).list),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeatMapPainter extends CustomPainter {
  Map<String, int> state;
  List<Room>? roomList;

  _HeatMapPainter(this.state, this.roomList);

  @override
  void paint(Canvas canvas, Size size) {
    double scale = calculateScale(size);
    rooms.map((e) => getRoomById(e.item1)).whereType<Room>().forEach((room) {
      Color? c = getColor(room);
      if (c != null) {
        drawRoom(canvas, room, c, scale);
      }
    });
  }

  Room? getRoomById(String id) {
    if (roomList == null) return null;
    return roomList!.getFirstOrNull((e) => e.room_id == id);
  }

  void drawRoom(Canvas canvas, Room r, Color fillWith, double scale,
      {Color strokeWith = Colors.black}) {
    Tuple2<String, ui.Path>? roomEn = rooms.getFirstOrNull((element) => element.item1 == r.room_id);
    if (roomEn != null) {
      ui.Path scaledPath = scalePath(roomEn.item2, scale);
      canvas.drawPath(
          scaledPath,
          Paint()
            ..color = fillWith
            ..style = PaintingStyle.fill);
      canvas.drawPath(
          scaledPath,
          Paint()
            ..color = strokeWith
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.0);
    }
  }

  double calculateScale(Size size) {
    return size.width.toDouble() / widthScale.toDouble();
  }

  Color? getColor(Room r) {
    return getColorForRoom(r.room_id, r.capacity, state.getOrNull(r.room_id));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// 横幅の基準値(この幅が画面幅に合うように拡大される)
const widthScale = 500;
// 縦幅(横幅に応じて拡大される)
const heightScale = 1500;
// Tuple<Room ID,Drawing Path>
final List<Tuple2<String, ui.Path>> rooms = [Tuple2("testroom", genSquare(0, 0, 100, 100)),Tuple2("test2room", genSquare(0, 0, 100, 100))];
final Map<Range, Color> colors = {
  Range.singleton(0).scale(0.1): Colors.grey,
  Range.singleton(1).scale(0.1): Colors.blueGrey,
  Range.singleton(2).scale(0.1): Colors.lightBlue,
  Range.singleton(3).scale(0.1): Colors.blue,
  Range.singleton(4).scale(0.1): Colors.lightGreen,
  Range.singleton(5).scale(0.1): Colors.green,
  Range.singleton(6).scale(0.1): Colors.yellow,
  Range.singleton(7).scale(0.1): Colors.orange,
  Range.singleton(8).scale(0.1): Colors.deepOrange,
  Range.singleton(9).scale(0.1): Colors.red,
  Range(1.0, double.maxFinite): Colors.deepPurple,
};
const Color defaultColor = Colors.grey;

Color? getColorForRoom(String room_id, int? capacity, int? now) {
  if (now == null) return defaultColor; // 初期値
  Tuple2<String, ui.Path>? en = rooms.getFirstOrNull((element) => element.item1 == room_id);
  if (en == null) {
    return null; // roomsにないルームは色を返さない
  } else {
    if (capacity != null) {
      double percentage = now.toDouble() / capacity.toDouble();
      return _getColorForValue(percentage);
    } else {
      return defaultColor;
    }
  }
}

Color _getColorForValue(double percentage) {
  return colors.getFirstOrNull((element) => element.key.contains(percentage))?.value ??
      defaultColor;
}

class Range {
  final double min;
  final double max;

  bool get isSingleton => min == max;

  Range(this.min, this.max);

  bool contains(double value) => value >= min && value <= max;

  factory Range.singleton(int value) => Range(value.toDouble(), value.toDouble() + 1.0);

  Range scale(double apply) {
    return Range(min * apply, max * apply);
  }
}

/// Util
ui.Path scalePath(ui.Path path, double scale) {
  return path.transform(Matrix4.diagonal3Values(scale, scale, 1.0).storage);
}
