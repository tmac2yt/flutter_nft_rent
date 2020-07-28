import 'package:client/constants/event_bus.dart';
import 'package:client/pages/common_web_page.dart';
import 'package:client/utils/common_utils.dart';
import 'package:client/utils/contract_utils.dart';
import 'package:client/utils/data_utils.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final String headImagePath;
  final List menuTitles;
  final List menuIcons;

  MyDrawer(
      {Key key, //key是view树种用于定位控件的，自定义widget必须要写
      @required this.headImagePath,
      @required this.menuTitles,
      @required this.menuIcons})
      : assert(headImagePath != null),
        assert(menuTitles != null),
        assert(menuIcons != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String loginInfo = ContractUtils.getAccountAddress() ?? 'Login';
    return Drawer(
      child: ListView.separated(
          //解决状态栏问题
          padding: EdgeInsets.all(0.0),
          itemBuilder: (context, index) {
            if (index == 0) {
              return FlatButton(
                padding: EdgeInsets.all(0.0),
                  onPressed: () async {
                    //扫描获取私钥
//                    BarcodeScanner.scan().then((scanResult){
//                      if (scanResult != null) {
//                        String privateKey = scanResult.rawContent;
//                        if (privateKey != null &&
//                            privateKey.isNotEmpty &&
//                            privateKey.length == 32) {
//                          ContractUtils.privateKey = privateKey;
//                          ContractUtils.initContracts(context).then((_){
//                            eventBus.fire(LoginEvent);
//                            Map<String, dynamic> map = Map();
//                            map[DataUtils.SP_PRIVATE_KEY] = privateKey;
//                            DataUtils.saveLoginInfo(map);
//                          });
//                        }
//                      }
//                    });
                    ContractUtils.privateKey = 'b7f17be35ed23a376efc826d3c4db1ca5de03ce2eefad03f6949bd922326ee8a';
                    ContractUtils.initContracts(context).then((_){
                      eventBus.fire(LoginEvent());
                      Map<String, dynamic> map = Map();
                      map[DataUtils.SP_PRIVATE_KEY] = ContractUtils.privateKey;
                      DataUtils.saveLoginInfo(map);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 300,
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0,right: 10.0),
                      child: Text(
                        loginInfo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(headImagePath),
                            fit: BoxFit.fill)),
                  ));
            }
            index--;
            return ListTile(
              leading: Icon(menuIcons[index]),
              title: Text(menuTitles[index]),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                //TODO
                switch (index) {
                  case 0:
                    _navPush(context, CommonWebPage(title: menuTitles[index],url: 'https://jingyan.baidu.com/article/aa6a2c1485c62f0d4c19c40e.html',));
                    break;
                  case 1:
                    _navPush(context, CommonWebPage(title: menuTitles[index],url: 'https://www.baidu.com/link?url=1Tq2L8SOwG22Vf9OmqPNhiP9rbBgJJbgvDov5JMMM5Oms_W9Bvn-usJY5jAb936iOb-2yXXbGFeH08be2VbbOq&wd=&eqid=9064211d000024a2000000055f1fed4d',));
                    break;
                  case 2:
                    _navPush(context, CommonWebPage(title: menuTitles[index],url: 'https://5f0246cc0f70ad0008eb2754--romantic-goldstine-1d74b6.netlify.app',));
                    break;
                  case 3:
                    CommonUtils.showToast(context, 'developing...');
                    break;
                }
              },
            );
          },
          separatorBuilder: (context, index) {
            if (index == 0) {
              return Divider(
                height: 0.0,
              );
            } else {
              return Divider(
                height: 1.0,
              );
            }
          },
          itemCount: menuTitles.length + 1),
    );
  }

  _navPush(BuildContext context, Widget page) {
    Navigator.of(context).pop(); //收起drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return page;
    }));
  }
}
