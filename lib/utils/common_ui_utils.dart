import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CommonUIUtils {
  static final imagePath = [
    'assets/images/decentraland.png',
    'assets/images/crypto_kitty.png',
    'assets/images/decentraland2.png',
    'assets/images/crypto_kitty2.png',
    'assets/images/spacecraft.png'
  ];

  static Widget buildImage(int index) {
    index = index % imagePath.length;
    return Image.asset(imagePath[index], fit: BoxFit.cover, width: 120.0);
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

  static Widget richTextWidget(String title, String content) {
    return RichText(
      text: TextSpan(
          text: '$title：',
          style: TextStyle(
              fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w300),
          children: <TextSpan>[
            TextSpan(
                text: '$content',
                style: TextStyle(fontSize: 16.0, color: Colors.blueGrey)),
          ]),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
