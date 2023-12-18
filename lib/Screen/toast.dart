import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toast(message) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      webPosition: "center",
      webBgColor: "linear-gradient(to right, #000000, #000000)",
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 15.0);
}
