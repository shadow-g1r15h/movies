import 'package:flutter/material.dart';

class SnackBarMessage {
  SnackBarMessage._privateConstructor();
  static final SnackBarMessage _instance =
      SnackBarMessage._privateConstructor();
  static SnackBarMessage get instance => _instance;

  showMessage({
    required BuildContext context,
    required String message,
    SnackBarAction? action,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        action: action,
        backgroundColor: Colors.grey,
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
