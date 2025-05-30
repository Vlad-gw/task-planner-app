import 'package:flutter/material.dart';
import 'package:punctualis_1/api/metrica.dart';
import 'package:punctualis_1/main_app/splash.dart';
import 'package:punctualis_1/sign/auth.dart';
import 'package:punctualis_1/sign/register.dart';
import 'package:punctualis_1/sign/main_page.dart';
import 'package:punctualis_1/sign/confirmation.dart';
import 'package:punctualis_1/main_app/dialogue_page.dart';
import 'package:punctualis_1/main_app/settings.dart';
import 'package:punctualis_1/main_app/calendar.dart';
import 'package:punctualis_1/api/api_service.dart';
import 'package:punctualis_1/widgets/custom_calendar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 103, 80, 164),
        ),
      ),
      home: const AuthWrapper(),
      routes: {
        '/reg': (context) => const Register(),
        '/auth': (context) => const Authorize(),
        '/conf': (context) => const Confirmation(),
        '/dlg': (context) => const DialoguePage(),
        '/sttgs': (context) => const Settings(),
        '/calend': (context) => const Calendar(),
        '/splash': (context) => const Splash(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});



  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final ApiService _apiService = ApiService();


  @override
  void initState() {
    super.initState();
    Metrica.init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _apiService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Splash();
        } else {
          if (snapshot.data == true) {
            return const CustomCalendar();
          } else {
            return const MainScreen();
          }
        }
      },
    );
  }
}
