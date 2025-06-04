import 'package:flutter/material.dart';
import 'package:punctualis_1/api/metrica.dart';
import 'package:punctualis_1/main_app/tab_page.dart';
import 'package:punctualis_1/structures/task.dart';
import 'package:punctualis_1/widgets/custom_calendar.dart';
import 'package:punctualis_1/styles/colors.dart';
import 'package:punctualis_1/controllers/tab_bar_controller.dart';
import 'package:punctualis_1/utils/json_handler.dart';
import 'package:punctualis_1/api/api_service.dart';
import 'package:json5/json5.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  ApiService apiService = ApiService();

  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    Metrica.screenOpen("Calendar");
    loadData();
  }

  Future<void> loadData() async {
    tasks = await JSONHandler.parseTasks((await apiService.getUserTasks()));
    for (var task in tasks) {
      print(task.title);
    }
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
                  itemCount: tasks.length,
                  itemBuilder:
                      (context, index) =>
                          ListTile(title: Text(tasks[index].title)),
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
      builder:
          (context) => AlertDialog(
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
        backgroundColor: Color.fromARGB(255, 236, 230, 240),
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: CustomCalendar(
                    initialDate: DateTime.now(),
                    onDateSelected: (date) {},
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: CustomColors.white.color,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: TabBarController(
                    tabScreens: [TabPage(title: '1', count: 1,), TabPage(title: '2', count: 2,), TabPage(title: '3', count: 3)],
                    tabs: [Tab(text: 'Мои планы'), Tab(text: 'В процессе'), Tab(text: 'Завершено')],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
