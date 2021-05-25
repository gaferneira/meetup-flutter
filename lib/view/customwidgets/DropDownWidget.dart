import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/model/entities/Category.dart';

class DropDownWidget extends StatefulWidget {
  final List<Category>? items;
  final Function(String?)? callback;

  DropDownWidget({Key? key, @required this.items, @required this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DropDownState();
  }
}

class _DropDownState extends State<DropDownWidget> {
  String dropdownValue = '';

  @override
  void initState() {
    dropdownValue = widget.items?[0].name ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      onSaved: (String? value) {
        widget.callback!(value);
      },
      items: widget.items?.map<DropdownMenuItem<String>>((Category value) {
        return DropdownMenuItem<String>(
          value: value.name,
          child: Text(value.name ?? ""),
        );
      }).toList(),
    );
  }
}