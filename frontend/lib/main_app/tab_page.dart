import 'package:flutter/material.dart';
import 'package:punctualis_1/structures/task.dart';
import 'package:punctualis_1/widgets/tab_page_list_item.dart';
class TabPage extends StatelessWidget {
  List<Task> tasks;

  TabPage({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          if (tasks.isNotEmpty) {
            return TabPageListItem(
                task: tasks[index]);
          }
        },
      ),
    );
  }
}