import 'package:flutter/material.dart';

class CustomYearPicker extends StatefulWidget {
  final int selectedYear;
  final int firstYear;
  final int lastYear;
  final String? hintText;
  final InputDecoration? decoration;

  const CustomYearPicker({
    Key? key,
    required this.selectedYear,
    required this.firstYear,
    required this.lastYear,
    this.hintText,
    this.decoration,
  }) : super(key: key);

  @override
  _CustomYearPicker createState() => _CustomYearPicker();
}

class _CustomYearPicker extends State<CustomYearPicker> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedYear;
  }

  @override
  Widget build(BuildContext context) {
    final years = List<int>.generate(
      widget.lastYear - widget.firstYear + 1,
          (index) => widget.firstYear + index,
    );

    return DropdownButtonFormField<int>(
      value: _selectedYear,
      items: years.map((year) {
        return DropdownMenuItem<int>(
          value: year,
          child: Text(year.toString()),
        );
      }).toList(),
      onChanged: (year) {
        if (year != null) {
          setState(() {
            _selectedYear = year;
          });
        }
      },
    );
  }
}