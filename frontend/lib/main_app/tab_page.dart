import 'package:flutter/material.dart';
class TabPage extends StatelessWidget {
  final String title;
  final int count;

  const TabPage({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Count: $count')),
    );
  }
}