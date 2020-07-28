import 'package:flutter/material.dart';

//回调函数：一个抽象类中只有一个方法，用typedef
typedef OnItemClickListener = bool Function(String data);

class SimpleListDialog extends Dialog {
  List dataList;
  OnItemClickListener onItemClickListener;

  SimpleListDialog(
      {Key key, @required this.dataList,this.onItemClickListener})
      : assert(dataList != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dataList == null) {
      return Center(
        child: Text(
          'data is empty',
          style: TextStyle(color: Colors.blue, fontSize: 25.0),
        ),
      );
    }

    return Container(
      decoration: ShapeDecoration(
        color: Color(0xffffffff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
      margin: const EdgeInsets.all(20),
      child: ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 60.0,
                child: Text(
                  dataList[index],
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25.0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              onTap: () {
                if (onItemClickListener != null) {
                  if(onItemClickListener.call(dataList[index])){
                    Navigator.of(context).pop('cancel');
                  }
                }
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1.0,
              color: Colors.black12,
            );
          },
          itemCount: dataList.length),
    );
  }
}
