import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    String? hintText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(137, 0, 183, 255)),
        ),
        focusedBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 76, 107, 175), width: 2)),
        hintText: hintText,
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.7)),
        labelText: labelText,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Color.fromARGB(255, 0, 68, 255))
            : null);
  }
}
