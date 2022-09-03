import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'PermissionScanPage.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  final TextEditingController _controller = TextEditingController();
  bool _state = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox.expand(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [
            Expanded(
                child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: "付与する権限名"),
                    onChanged: (String _) {
                      setState(() {});
                    })),
            DropdownButton<bool>(
              items: const [
                DropdownMenuItem(
                  value: true,
                  child: Text("true"),
                ),
                DropdownMenuItem(
                  value: false,
                  child: Text("false"),
                ),
              ],
              onChanged: (bool? value) {
                setState(() {
                  _state = value!;
                });
              },
              value: _state,
            )
          ]),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _controller.text.isEmpty
                ? null
                : () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => PermissionScanPage(
                              toGrant: {_controller.text: _state},
                            )));
                  },
            child: const Text("権限付与"),
          ),
        ],
      )),
    );
  }
}
