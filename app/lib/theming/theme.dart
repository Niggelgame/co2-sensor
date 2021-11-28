import 'package:flutter/material.dart';

class Co2Theme {
  static ThemeData lightTheme = ThemeData(
    backgroundColor: Color(0xFFC1C9E8),
    colorScheme: ColorScheme.light(
      secondary: Color(0xFFA2E889),
      surface: Color(0xFFF2F2F2),
      secondaryVariant: Colors.grey.shade300,
    ),
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 34.5, fontWeight: FontWeight.w700),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    backgroundColor: Color(0xFF1D1D1D),
    colorScheme: ColorScheme.dark(
      secondary: Color(0xFFA2E889),
      surface: Color(0xFF1D1D1D),
      secondaryVariant: Color(0xff37434d),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 34.5, fontWeight: FontWeight.w700),
    ),
  );
}
