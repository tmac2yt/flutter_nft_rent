import 'package:client/pages/lessor_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LesseeList extends StatefulWidget {
  @override
  _LesseeListState createState() => _LesseeListState();
}

class _LesseeListState extends State<LesseeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessor list'),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LessorOrder()));
              },
              child: Icon(
                Icons.add,
              )),
        ],
      ),
    );
  }
}
