import 'package:client/constants/constants.dart';
import 'package:client/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //显示布局边界
//    debugPaintSizeEnabled = true;
    return MaterialApp(
      //去掉右上角debug标签
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(AppColors.APP_THEME)),
      home: HomePage(),
    );
  }
}


