import 'package:flutter/material.dart';

enum CustomColors {
  purple,
  white,
  black,
  grey,
}

extension CustomColorsExtension on CustomColors {
  Color get color {
    switch (this) {
      case CustomColors.purple:
        return const Color.fromARGB(255, 103, 80, 164);
      case CustomColors.white:
        return const Color.fromARGB(255, 255, 255, 255);
      case CustomColors.black:
        return const Color.fromARGB(255, 0, 0, 0);
      case CustomColors.grey:
        return const Color.fromARGB(255, 236, 230, 240);
      default:
        return const Color.fromARGB(255, 0, 0, 0); // fallback
    }
  }
}