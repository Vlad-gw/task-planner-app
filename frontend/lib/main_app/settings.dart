import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showLeftSideMenu() {
    _scaffoldKey.currentState?.openDrawer();
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

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Color.fromARGB(255, 236, 230, 240);

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
                        Image(image: AssetImage("assets/avatar1.png"),
                        ),
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
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Версия 0.5.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _showLeftSideMenu,
        ),
        title: const Text("Punctualis"),
        centerTitle: true,
        backgroundColor: backgroundColor,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Выбрано: $value')));
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'settings',
                    child: Text('Настройки'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'help',
                    child: Text('Помощь'),
                  ),
                ],
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 230, 240),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text("Настройки"),
              ),
              Image(
                image: AssetImage("assets/avatar1.png"),
                width: 100,
                height: 100,

              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Имя',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Фамилия',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true, // включение заливки
                  fillColor: Colors.white, // цвет заливки
                ),
              ),

              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, 43),
                ),
                child: const Text("Применить изменения"),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 43),
                ),
                child: const Text('Выйти из приложения'),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 43),
                ),
                child: const Text('Выйти из аккаунта'),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 43),
                ),
                child: const Text(
                  'Удалить аккаунт',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
