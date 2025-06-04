import 'package:flutter/material.dart';
import 'package:punctualis_1/structures/task.dart';
import 'package:punctualis_1/widgets/tab_page_list_item.dart';
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
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return TabPageListItem(
           task: Task(title: 'Помыть посуду', description: 'description', priority: 1, creationDate: 15645, finishDate: 4546456, isDone: true, timeReminder: 4564564, scheduledAt: 44846)
          );
        },
      ),
    );
  }
}