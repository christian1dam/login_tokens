import 'package:flutter/material.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    late SnackBar snackBar = const SnackBar(content: Text(''),);
    if (message == "INVALID_LOGIN_CREDENTIALS") {
      snackBar = const SnackBar(
        content: Text(
          'Datos no encontrados en la base de datos',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    }
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
