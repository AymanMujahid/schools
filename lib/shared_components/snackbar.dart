import 'package:flutter/material.dart';

class SteveSnackBar{
  snackBar(String? message,context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}