import 'package:flutter/material.dart';
import 'package:punctualis_1/structures/task.dart';

class TabPageListItem extends StatelessWidget {
  final Task task;

  const TabPageListItem({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Checkbox(
              value: task.isDone,
              onChanged: (bool? value) {
              },
            ),
            Text(task.title),
            Image.asset('assets/icons/edit.png'),
            Image.asset('assets/icons/delete.png')
          ],
        ),
      ),
    );
  }
}
