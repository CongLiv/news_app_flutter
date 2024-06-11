import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'const_data.dart';
class ToastLog {
  static void show(String message){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: redViettel,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}