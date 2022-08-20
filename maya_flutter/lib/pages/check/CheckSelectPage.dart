import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maya_flutter/api/models/Models.dart';
import 'package:maya_flutter/models/RoomsProvider.dart';
import 'package:maya_flutter/pages/check/CheckPage.dart';
import 'package:provider/provider.dart';

class CheckSelectPage extends StatefulWidget {
  const CheckSelectPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckSelectPageState();
}

class _CheckSelectPageState extends State<CheckSelectPage> {
  Room? _selectedRoom;
  Operation _operation = Operation.Enter;
  List<Room>? _rooms;
  List<DropdownMenuItem<Room>>? _dropdownRooms;

  final List<DropdownMenuItem<Operation>> _dropdownOperations = Operation.values.map((e) {
    return DropdownMenuItem<Operation>(
      value: e,
      child: Text(e.operationDisplayName),
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    if (_rooms == null) {
      List<Room>? _r = Provider.of<RoomsProvider>(context, listen: true).list;
      if (_r != null) {
        setState(() {
          _rooms = _r;
          _dropdownRooms = _rooms?.map((e) {
            return DropdownMenuItem<Room>(
              value: e,
              child: Text(e.display_name),
            );
          }).toList();
        });
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('CheckSelectPage'),
            DropdownButton<Room>(
              items: _dropdownRooms,
              value: _selectedRoom,
              onChanged: (Room? index) {
                setState(() {
                  _selectedRoom = index!;
                });
              },
            ),
            DropdownButton<Operation>(
              items: _dropdownOperations,
              value: _operation,
              onChanged: (Operation? op) {
                setState(() {
                  _operation = op!;
                });
              },
            ),
            ElevatedButton(
                onPressed: _selectedRoom == null
                    ? null
                    : () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CheckPage(selectedRoom: _selectedRoom!, operation: _operation)));
                      },
                child: const Text("読み取り開始"))
          ],
        ),
      ],
    );
  }
}
