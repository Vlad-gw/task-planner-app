import 'package:flutter/material.dart';
import 'package:punctualis_1/api/api_service.dart';
import 'package:punctualis_1/structures/task.dart';
import 'package:punctualis_1/styles/colors.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTask();
}

class _CreateTask extends State<CreateTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Создание задачи"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // color: CustomColors.grey.color,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Название задачи',
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    TextField(),
                    Text('Время начала задачи'),
                    Row(children: [TextField(), TextField()]),
                    Text('Время конца задачи'),
                    Row(children: [TextField(), TextField()]),
                    Slider(
                      value: 3,
                      min: 1,
                      max: 5,
                      onChanged: (double newValue) {},
                    ),
                    Text('Время напоминания'),
                    Row(children: [TextField(), TextField()]),
                  ],
                ),
              ),
            ),
          ),
          Row(children: [Text('Сохранить'), Text('Закрыть')]),
        ],
      ),
    );
  }
}
