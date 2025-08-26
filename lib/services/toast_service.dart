import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastService {
  static void showNiceToast() {
    Fluttertoast.showToast(
      msg: "Nice!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP_RIGHT,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green.shade600,
      textColor: Colors.white,
      fontSize: 18.0
    );
  }

  static void showWelcomeToast() {
    Fluttertoast.showToast(
      msg: "Velkommen!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP_RIGHT,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.blue.shade600,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }
}