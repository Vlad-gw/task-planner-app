import 'package:flutter/material.dart';
import 'package:punctualis_1/sign/auth.dart';
import 'package:punctualis_1/sign/register.dart';
import 'package:punctualis_1/sign/main_page.dart';
import 'package:punctualis_1/sign/confirmation.dart';
import 'package:punctualis_1/main_app/dialogue_page.dart';

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
    initialRoute: '/',
    routes: {
      '/': (context) => const MainScreen(),
      '/reg': (context) => const Register(),
      '/auth': (context) => const Authorize(),
      '/conf': (context) => const Confirmation(),
      '/dlg': (context) => const DialoguePage(),

    },
  );
  }
}
