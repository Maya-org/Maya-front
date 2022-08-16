import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ui/UI.dart';

class HeadCountPage extends StatefulWidget {
  final void Function(BuildContext context, int adult, int child, int parent, int student) onSubmit;
  final String title;
  final String? init_adult;
  final String? init_child;
  final String? init_parent;
  final String? init_student;

  const HeadCountPage({Key? key, required this.onSubmit, required this.title, this.init_adult, this.init_child, this.init_parent, this.init_student}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeadCountPageState();
}

class _HeadCountPageState extends State<HeadCountPage> {
  late TextEditingController _adult;
  late TextEditingController _child;
  late TextEditingController _parent;
  late TextEditingController _student;

  @override
  void initState(){
    super.initState();
    _adult = TextEditingController(text: widget.init_adult ?? "0");
    _child = TextEditingController(text: widget.init_child ?? "0");
    _parent = TextEditingController(text: widget.init_parent ?? "0");
    _student = TextEditingController(text: widget.init_student ?? "0");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
              labelText: '予約人数(大人)',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _adult,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: '予約人数(子供)',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _child,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: '予約人数(保護者)',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _parent,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: '予約人数(生徒)',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _student,
          ),
          ElevatedButton(
              onPressed: () {
                int adult = int.tryParse(_adult.text) ?? 0;
                int child = int.tryParse(_child.text) ?? 0;
                int parent = int.tryParse(_parent.text) ?? 0;
                int student = int.tryParse(_student.text) ?? 0;
                showOKDialog(context, title: const Text("予約しますか?"), body: Text("""${widget.title}
大人:${_adult.text}人
子供:${_child.text}人
保護者:${_parent.text}人
生徒:${_student.text}人"""), onOK: () {
                  widget.onSubmit(context, adult, child, parent, student);
                }, toClose: false);
              },
              child: const Text("予約する"))
        ],
      ),
    );
  }
}
