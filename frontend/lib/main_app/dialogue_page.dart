import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:punctualis_1/api/api_service.dart';
import 'package:punctualis_1/api/metrica.dart';
import 'package:punctualis_1/structures/message.dart';
import 'package:punctualis_1/utils/json_handler.dart';

class DialoguePage extends StatefulWidget {
  const DialoguePage({super.key});

  @override
  State<DialoguePage> createState() => _DialoguePageState();
}

class _DialoguePageState extends State<DialoguePage> {
  bool isLoading = false;
  final List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Metrica.screenOpen("DialoguePage");
  }

  Future<void> _sendMessage() async {
    try {
      print('started');
      ApiService apiService = ApiService();
      final text = _controller.text;
      if (text.isNotEmpty) {
        final now = DateFormat('HH:mm').format(DateTime.now());
        Message request = Message(text: text, time: now, isUser: true);
        messages.add(request);
        setState(() => isLoading = true);
        String answer = await JSONHandler.parseMessage(
          await apiService.sendMessage(request),
        );
        setState(() {
          messages.add(Message(text: answer, time: now, isUser: false));
          _controller.clear();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  void _showLeftSideMenu() {
    _scaffoldKey.currentState?.openDrawer();
    Metrica.navigationMenuUsed();
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
    final theme = Theme.of(context);

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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  color: backgroundColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isUserMessage = message.isUser;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Align(
                          alignment:
                              isUserMessage
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment:
                                isUserMessage
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  message.text,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                message.time,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color:
                    theme.inputDecorationTheme.fillColor ?? theme.canvasColor,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.grey),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Сообщение',
                        hintStyle: TextStyle(color: theme.hintColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print('pressed');
                      _sendMessage();
                    },
                    child: Image.asset(
                      'assets/icons/send.png',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
