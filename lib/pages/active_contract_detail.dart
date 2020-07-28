import 'package:client/constants/event_bus.dart';
import 'package:client/models/active_contract.dart';
import 'package:client/models/rent_list.dart';
import 'package:client/pages/lessor_order.dart';
import 'package:client/utils/common_ui_utils.dart';
import 'package:client/utils/common_utils.dart';
import 'package:client/utils/contract_utils.dart';
import 'package:client/utils/data_utils.dart';
import 'package:client/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:web3dart/web3dart.dart';

class ActiveContractDetail extends StatefulWidget {
  ActiveContract activeContract;

  ActiveContractDetail(this.activeContract);

  @override
  _ActiveContractDetailState createState() =>
      _ActiveContractDetailState(activeContract);
}

class MyKeyValue {
  String key;
  String value;

  MyKeyValue({@required this.key, @required this.value}) : assert(key != null);
}

class _ActiveContractDetailState extends State<ActiveContractDetail> {
  int curPage = 1;
  List<MyKeyValue> list;
  ActiveContract activeContract;

  _ActiveContractDetailState(this.activeContract);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (activeContract != null) {
      MyKeyValue myKeyValue =
          new MyKeyValue(key: 'tokenId', value: activeContract.tokenId);
      list.add(myKeyValue);
      MyKeyValue myKeyValue1 =
          new MyKeyValue(key: 'lessor', value: activeContract.lessor);
      list.add(myKeyValue1);
      MyKeyValue myKeyValue2 =
          new MyKeyValue(key: 'tenant', value: activeContract.tenant);
      list.add(myKeyValue2);
      String startTime = DateUtils.convertIntToString(activeContract.startTime);
      MyKeyValue myKeyValue3 =
          new MyKeyValue(key: 'startTime', value: startTime);
      list.add(myKeyValue3);
      String lastTime = DateUtils.convertIntToString(activeContract.lastTime);
      MyKeyValue myKeyValue4 = new MyKeyValue(key: 'endTime', value: lastTime);
      list.add(myKeyValue4);
      MyKeyValue myKeyValue5 = new MyKeyValue(
          key: 'securityDeposit', value: activeContract.securityDeposit);
      list.add(myKeyValue5);
      MyKeyValue myKeyValue6 =
          new MyKeyValue(key: 'rent', value: activeContract.rent);
      list.add(myKeyValue6);
      MyKeyValue myKeyValue7 =
          new MyKeyValue(key: 'balance', value: activeContract.balance);
      list.add(myKeyValue7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildCenter(),
      appBar: AppBar(
        title: Text('active contract detail'),
        elevation: 0.0,
      ),
    );
  }

  Center buildCenter() {
    return Center(
        child: Column(children: <Widget>[
      ListView.separated(
          itemBuilder: (context, index) {
            MyKeyValue keyValue = list[index];
            return ListTile(
              leading: Icon(Icons.subtitles),
              title: Text(
                keyValue.key,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                keyValue.value,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: list.length),
    ]));
  }
}
