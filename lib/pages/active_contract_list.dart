import 'package:client/constants/event_bus.dart';
import 'package:client/models/active_contract.dart';
import 'package:client/models/rent_list.dart';
import 'package:client/pages/active_contract_detail.dart';
import 'package:client/pages/lessor_order.dart';
import 'package:client/utils/common_ui_utils.dart';
import 'package:client/utils/common_utils.dart';
import 'package:client/utils/contract_utils.dart';
import 'package:client/utils/data_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:web3dart/web3dart.dart';

class ActiveContractList extends StatefulWidget {
  @override
  _ActiveContractListState createState() => _ActiveContractListState();
}

class _ActiveContractListState extends State<ActiveContractList> {
  int curPage = 1;
  List<ActiveContract> activeContractList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LoginEvent>().listen((event) {
      getActiveContractList();
    });
  }

  getActiveContractList() async {
    await ContractUtils.getActiveContractList().then((data) {
      if (data != null) {
        activeContractList = List();
        for (int i = 0; i < data.length; i++) {
          List<dynamic> list = data[i];
          if (list != null && list.isNotEmpty) {
            String tokenId = list[0].toString();
            String lessor = list[1].toString();
            String tenant = list[2].toString();
            String leasingSchedule = list[3].toString();
            int startTime = list[4];
            int lastTime = list[5];
            double securityDeposit =
                EtherAmount.fromUnitAndValue(EtherUnit.kwei, list[6])
                        .getInEther
                        .toDouble() /
                    1000;
            double rent = EtherAmount.fromUnitAndValue(EtherUnit.kwei, list[7])
                    .getInEther
                    .toDouble() /
                1000;
            int leasingTime = list[8];
            int payCount = list[9];
            double balance =
                EtherAmount.fromUnitAndValue(EtherUnit.kwei, list[10])
                        .getInEther
                        .toDouble() /
                    1000;

            ActiveContract activeContract = new ActiveContract(
                tokenId: tokenId,
                lessor: lessor,
                tenant: tenant,
                leasingSchedule: leasingSchedule,
                leasingTime: leasingTime,
                startTime: startTime,
                lastTime: lastTime,
                payCount: payCount,
                balance: balance,
                securityDeposit: securityDeposit,
                rent: rent);
            activeContractList.add(activeContract);
          }
        }
        if (activeContractList != null) {
          if (mounted) {
            setState(() {});
          }
        }
      }
    });
  }

  Future<void> _pullToRefresh() async {
    await getActiveContractList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullToRefresh,
      child: Scaffold(
        body: buildListView(),
        appBar: AppBar(
          title: Text('active contract list'),
          elevation: 0.0,
        ),
      ),
    );
  }

  Widget buildListView() {
    if (activeContractList == null) {
      getActiveContractList();
      return Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      );
    }

    if (activeContractList.length == 0) {
      return CommonUIUtils.buildListViewEmpty();
    }

    return GridView.builder(
        itemCount: activeContractList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          ActiveContract activeContract = activeContractList[index];
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  CommonUIUtils.buildImage(index),
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text(
                      'tokenId:',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w300),
                    ),
                    subtitle: Text(
                      activeContract.tokenId,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ActiveContractDetail(activeContract)));
            },
          );
        });
  }
}
