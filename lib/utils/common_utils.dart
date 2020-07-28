import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CommonUtils {
  static showToast(BuildContext context, String content) {
    FlutterToast(context).showToast(
        toastDuration: Duration(seconds: 3),
        child: new Text(
          content,
          style: TextStyle(fontSize: 20.0, color: Colors.red),
        ),
        gravity: ToastGravity.CENTER);
  }

  static AlertDialog commonDialog(BuildContext context,String title,String content,Function onConfirmPressed){
    return AlertDialog(
      title: Text(title??''),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text('cancel'),
          onPressed: () {
            Navigator.of(context).pop('cancel');
          },
        ),
        FlatButton(
          child: Text('confirm'),
          onPressed: () {
            if(onConfirmPressed != null) {
              onConfirmPressed.call();
            }
            Navigator.of(context).pop('confirm');
          },
        ),
      ],
    );
  }
}
