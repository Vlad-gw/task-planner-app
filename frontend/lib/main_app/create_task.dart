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
  double sliderValue = 3;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: CustomColors.grey.color,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: TextField(
                      controller: _titleController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Название задачи',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    height: 120,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: CustomColors.grey.color,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: TextField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Описание задачи (опционально)',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Время начала задания',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 100,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  color: CustomColors.grey.color,
                                ),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '00',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text('Часы'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(child: Text(':')),
                      SizedBox(
                        width: 120,
                        height: 100,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  color: CustomColors.grey.color,
                                ),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '00',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text('Минуты'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Время конца задания',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 100,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  color: CustomColors.grey.color,
                                ),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '00',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text('Часы'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(child: Text(':')),
                      SizedBox(
                        width: 120,
                        height: 100,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  color: CustomColors.grey.color,
                                ),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '00',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text('Минуты'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: sliderValue,
                    min: 1,
                    max: 5,
                    divisions: 5,
                    onChanged: (double newValue) {
                      setState(() {
                        sliderValue = newValue;
                      });
                    },
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    child: Text('Время Напоминания', textAlign: TextAlign.left),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 100,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  color: CustomColors.grey.color,
                                ),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '00',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text('Часы'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(child: Text(':')),
                      SizedBox(
                        width: 120,
                        height: 100,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  color: CustomColors.grey.color,
                                ),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: '00',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text('Минуты'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(color: CustomColors.grey.color),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(16),
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: CustomColors.purple.color,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: Center(
                  child: TextButton(
                    child: Text(
                      'Сохранить',
                      style: TextStyle(color: CustomColors.white.color),
                    ),
                    onPressed: () {
                      // Task task = Task(title: , description: description, priority: priority, creationDate: creationDate, finishDate: finishDate, isDone: isDone, timeReminder: timeReminder, scheduledAt: scheduledAt)
                    },
                  ),
                ),
              ),
              Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: CustomColors.white.color,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: CustomColors.purple.color),
                ),
                child: Center(
                  child: TextButton(
                    child: Text(
                      'Закрыть',
                      style: TextStyle(color: CustomColors.purple.color),
                    ),
                    onPressed: () {Navigator.pop(context);},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
