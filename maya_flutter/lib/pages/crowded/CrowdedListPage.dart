import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:maya_flutter/component/heatMap/HeatMap.dart';
import 'package:maya_flutter/models/HeatMapChangeNotifier.dart';
import 'package:maya_flutter/models/RoomsProvider.dart';
import 'package:maya_flutter/ui/DefaultAppBar.dart';
import 'package:maya_flutter/util/CollectionUtils.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../api/models/Models.dart';

class CrowdedListPage extends StatefulWidget {
  const CrowdedListPage({Key? key}) : super(key: key);

  @override
  State<CrowdedListPage> createState() => _CrowdedListPageState();
}

class _CrowdedListPageState extends State<CrowdedListPage> {
  List<CrowdedListEntry> _baseCount = [];
  List<CrowdedListEntry> _baseSum = [];
  List<CrowdedListEntry> _sorted = [];
  ComparatorType _type = ComparatorType.COUNT;

  @override
  Widget build(BuildContext context) {
    updateList(Provider.of<RoomsProvider>(context).list ?? [],
        Provider.of<HeatMapChangeNotifier>(context));

    return Scaffold(
      appBar: defaultAppBar('混雑状況一覧'),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: double.infinity,
              child: MaterialSegmentedControl(
                unselectedColor: Colors.white,
                selectedColor: Colors.blue,
                selectionIndex: _type,
                children: const {
                  ComparatorType.COUNT: Text("人数"),
                  ComparatorType.NAME: Text("部屋名"),
                  ComparatorType.PERCENTAGE: Text("混雑率"),
                  ComparatorType.SUM: Text("累計人数"),
                },
                onSegmentChosen: (ComparatorType type) {
                  setState(() {
                    _type = type;
                  });
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                    itemBuilder: (ctx, index) => _sorted[index],
                    itemCount: _sorted.length,
                    shrinkWrap: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateList(List<Room> list, HeatMapChangeNotifier notifier) {
    Map<String, int> count = notifier.guestCount;
    _baseCount = list
        .map((Room room) {
          MapEntry<String, int>? en = count.getFirstOrNull((e) => e.key == room.room_id);
          if (en != null) {
            return Tuple2(room, en.value);
          }
          return null;
        })
        .toList()
        .filterNotNull()
        .filter((Tuple2<Room, int> element) =>
            rooms.any((r) => r.item1 == element.item1.room_id)) // roomsに記載があるものだけにする
        .map((Tuple2<Room, int> element) {
          return CrowdedListEntry(
            room: element.item1,
            count: element.item2,
          );
        })
        .toList();

    Map<String, int> sum = notifier.guestCountSum;
    _baseSum = list
        .map((Room room) {
          MapEntry<String, int>? en = sum.getFirstOrNull((e) => e.key == room.room_id);
          if (en != null) {
            return Tuple2(room, en.value);
          }
          return null;
        })
        .toList()
        .filterNotNull()
        .filter((Tuple2<Room, int> element) =>
            rooms.any((r) => r.item1 == element.item1.room_id)) // roomsに記載があるものだけにする
        .map((Tuple2<Room, int> element) {
          return CrowdedListEntry(
            room: element.item1,
            count: element.item2,
          );
        })
        .toList();
    _doSort();
  }

  void _doSort() {
    _sorted = _baseCount.toList();
    switch (_type) {
      case ComparatorType.NAME:
        _sorted.sort((CrowdedListEntry a, CrowdedListEntry b) =>
            b.room.display_name.compareTo(a.room.display_name)); // TODO 挙動が不明
        break;
      case ComparatorType.COUNT:
        _sorted.sort((CrowdedListEntry a, CrowdedListEntry b) => b.count.compareTo(a.count));
        break;
      case ComparatorType.PERCENTAGE:
        _sorted.sort((CrowdedListEntry a, CrowdedListEntry b) {
          if (a.percentage == null) {
            return 1;
          } else if (b.percentage == null) {
            return -1;
          }
          return b.percentage!.compareTo(a.percentage!);
        });
        break;
      case ComparatorType.SUM:
        _sorted = _baseSum.toList();
        _sorted.sort((CrowdedListEntry a, CrowdedListEntry b) => b.count.compareTo(a.count));
        break;
    }
  }
}

enum ComparatorType { NAME, COUNT, PERCENTAGE, SUM }

class CrowdedListEntry extends StatefulWidget {
  final Room room;
  final int count;
  late double? percentage;

  CrowdedListEntry({Key? key, required this.room, required this.count}) : super(key: key) {
    if (room.capacity != null) {
      percentage = count / room.capacity!.toDouble();
    } else {
      percentage = null;
    }
  }

  @override
  State<CrowdedListEntry> createState() => _CrowdedListEntryState();
}

class _CrowdedListEntryState extends State<CrowdedListEntry> {
  static String body(int count, int? capacity) {
    if (capacity != null) {
      return "$count/$capacity";
    }
    return "$count";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.room.display_name),
          trailing: Text(body(widget.count, widget.room.capacity)),
        ),
        Container(
          height: 1,
          color: getColorForRoom(widget.room.room_id, widget.room.capacity, widget.count)!,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
