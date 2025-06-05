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
              value: task.isDone ?? false,
              onChanged: (bool? newValue) {
              },
            ),
            Expanded(child: Text(task.title)),
            Image.asset('assets/icons/edit.png'),
            Image.asset('assets/icons/delete.png'),
            Container(
              width: 36,
              height: 36,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Center(
                child: Text(
                  task.priority.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
