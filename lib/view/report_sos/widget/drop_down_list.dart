import 'package:flutter/material.dart';

const List<String> list = <String>['Loại sự cố', 'Two', 'Three', 'Four'];

class DropdownList extends StatefulWidget {
  const DropdownList({super.key});

  @override
  State<DropdownList> createState() => _DropdownList();
}

class _DropdownList extends State<DropdownList> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      inputDecorationTheme: const InputDecorationTheme(
          filled: true, contentPadding: EdgeInsets.all(10)),
      expandedInsets: const EdgeInsets.all(0),
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
