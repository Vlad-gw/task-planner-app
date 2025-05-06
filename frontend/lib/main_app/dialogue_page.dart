import 'package:flutter/material.dart';

class DialoguePage extends StatefulWidget {
  const DialoguePage({super.key});

  @override
  State<DialoguePage> createState() => _DialoguePageState();
}

class _DialoguePageState extends State<DialoguePage> {
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _sendMessage() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      setState(() {
        messages.add("Вы: $text");
        messages.add(
            "Здравствуйте. Извините. Я не могу сейчас ответить. Напиши позже :)");
      });
      _controller.clear();
    }
  }

  void _showLeftSideMenu() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Widget _buildMenuButton(String text) {
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
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Выбрано: $text')));
        },
        child: SizedBox(
          width: double.infinity, // Растягиваем на всю ширину кнопки
          child: Center(
            // Центрируем текст
            child: Text(text, style: TextStyle(fontSize: 16)),
          ),
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
        width: MediaQuery
            .of(context)
            .size
            .width * 0.8,
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
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        16.0,
                      ), // Закругление углов
                    ),
                    child: Text(
                      "Punctualis",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              _buildMenuButton('Чат'),
              _buildMenuButton('Календарь'),
              _buildMenuButton('Аналитика'),
              _buildMenuButton('Настройки'),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Версия 1.0.0',
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(message),
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
                  IconButton(
                    icon: CustomPaint(
                      size: Size(24, 24),
                      painter: TrianglePainter(color: theme.primaryColor),
                    ),
                    onPressed: _sendMessage,
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

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paintFill =
    Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    final paintBorder =
    Paint()
      ..color = const Color.fromARGB(255, 78, 76, 76)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
