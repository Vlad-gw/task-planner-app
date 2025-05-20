import 'package:flutter/material.dart';
import 'package:punctualis_1/utils/triangle.dart';
import 'package:punctualis_1/api/api_service.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 220, 224),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomPaint(
                   painter: TrianglePainter(cornerRadius: 3),
                   size: Size(80, 80),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 154, 160, 166),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      SizedBox(width: 25),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 154, 160, 166),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text("1st",style:TextStyle(
                            color: const Color.fromARGB(255, 218, 220, 224),
                            fontSize: 17,
                          ),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Text(
              "Добро пожаловать!",
              style: TextStyle(fontSize: 25.0),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 60),
              child: const Text(
                "Ваш персональный ассистент для планирования, анализа продуктивности и оптимизации времени «Punctualis»",
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/reg');
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, 43),
                    ),
                    child: const Text("Регистрация"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/auth');
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 43),
                      side: BorderSide(
                        width: 3.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: const Text("Авторизация"),
                  ),
                  TextButton(
                    onPressed: () {
                      final ApiService _apiService = ApiService();
                      Map<String, dynamic>? _responseData;
                      String _error = '';
                      Future<void> _fetchData() async {
                        final data = await _apiService.getAllUsers();
                      }
                      final snackBar = SnackBar(
                        content: Text(_fetchData().toString()),
                        action: SnackBarAction(
                          label: 'Отмена',
                          onPressed: () {
                            // Действие при нажатии
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, 43),
                    ),
                    child: const Text('Продолжить как гость'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

