import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:punctualis_1/api/metrica.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  Map<DateTime, List<String>> tasks = {};


  @override
  void initState() {
    super.initState();
    Metrica.screenOpen("Calendar");
  }

    Widget _buildMenuButton(String text, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 236, 230, 240),
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 16.0),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: SizedBox(
          child: Center(child: Text(text, style: TextStyle(fontSize: 16))),
        ),
      ),
    );
  }

  void _showLeftSideMenu() {
    _scaffoldKey.currentState?.openDrawer();
    Metrica.navigationMenuUsed();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _showTaskMenu(selectedDay);
  }

  // Показываем меню задач
  void _showTaskMenu(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    final dayTasks = tasks[dateKey] ?? [];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 300,
          child: Column(
            children: [
              Text(
                'Задачи на ${dateKey.toLocal().toString().split(' ')[0]}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: dayTasks.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(dayTasks[index]),
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Добавить задачу'),
                onPressed: () {
                  Navigator.pop(context);
                  _showAddTaskDialog(dateKey);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddTaskDialog(DateTime dateKey) {
    final TextEditingController taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Новая задача'),
        content: TextField(
          controller: taskController,
          decoration: InputDecoration(hintText: 'Введите задачу'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final taskText = taskController.text.trim();
              if (taskText.isNotEmpty) {
                setState(() {
                  if (tasks.containsKey(dateKey)) {
                    tasks[dateKey]!.add(taskText);
                  } else {
                    tasks[dateKey] = [taskText];
                  }
                  Metrica.taskCreate(taskText);
                });
                Navigator.pop(context);

                _showTaskMenu(dateKey);
              }
            },
            child: Text('Добавить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 236, 230, 240),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Row(
                      children: [
                        Image(image: AssetImage("assets/avatar1.png")),
                        SizedBox(width: 10),
                        Text(
                          "Имя Фамилия",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildMenuButton('Чат', '/dlg'),
              _buildMenuButton('Календарь', '/calend'),
              _buildMenuButton('Аналитика', '/sttgs'),
              _buildMenuButton('Настройки', '/sttgs'),
              // ваши кнопки меню
            ],
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Punctualis"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 236, 230, 240)
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 230, 240),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(28),
                ),
                  child: Material(
                    color: Colors.transparent,
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: _onDaySelected,
                      headerVisible: false,
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        selectedDecoration: BoxDecoration(
                          color: themeColor,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                        ),
                      ),
                    ),
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}