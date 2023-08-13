   import 'package:flutter/material.dart';

   
    showInSnackBar(String value,BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    ScaffoldMessenger.of(context)?.removeCurrentSnackBar();
     ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
        backgroundColor: Colors.black,
      duration: Duration(seconds: 2),
    ));
  }