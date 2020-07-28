import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CommonUIUtils {
  static Widget buildImage(int index) {
    if (index.isOdd) {
      return Image.asset('assets/images/decentraland.png',
          width: 109.0, height: 67.0);
    } else {
      return Image.asset('assets/images/crypto_kitty.png',
          width: 109.0, height: 73.0);
    }
  }

  static Text buildText(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 13.0,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Container buildSubTitle(String title) {
    return Container(
        child: Align(
          child: Text(
            title,
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.blue,
        ));
  }

  static BoxDecoration buildBoxDecorationBottom() {
    return BoxDecoration(
      border: Border(bottom: BorderSide(width: 1.0, color: Colors.black12)),
    );
  }

  static Center buildListViewEmpty() {
    return Center(
      child: Text(
        'data is empty',
        style: TextStyle(color: Colors.blue, fontSize: 25.0),
      ),
    );
  }
}
