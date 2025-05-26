import 'package:flutter/material.dart';
import 'package:punctualis_1/api/metrica.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  @override
  void initState() {
    super.initState();
    Metrica.screenOpen("Splash");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Center(
          child: Image.asset('assets/logo.png'),
        )
    );
    throw UnimplementedError();
  }
}
