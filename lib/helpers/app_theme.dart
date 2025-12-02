import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.blue;

  static InputDecoration inputDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    );
  }

  static ButtonStyle elevatedButtonStyle({required Color bg}) {
    return ElevatedButton.styleFrom(backgroundColor: bg);
  }
}