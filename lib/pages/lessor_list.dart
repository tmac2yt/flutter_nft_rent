import 'package:client/constants/event_bus.dart';
import 'package:client/models/rent_list.dart';
import 'package:client/pages/lessor_order.dart';
import 'package:client/utils/common_ui_utils.dart';
import 'package:client/utils/common_utils.dart';
import 'package:client/utils/contract_utils.dart';
import 'package:client/utils/data_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:web3dart/web3dart.dart';

class LessorList extends StatefulWidget {
  @override
  _LessorListState createState() => _LessorListState();
}

class _LessorListState extends State<LessorList> {
  int curPage = 1;
  List<RentList> lessorList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<LessorListEvent>().listen((event) {
      getLessorList();
    });
    eventBus.on<LoginEvent>().listen((event) {
      getLessorList();
    });
  }

  getLessorList() async {
    await ContractUtils.getLessorList().then((data) {
      if (data != null) {
        lessorList = List();
        for (int i = 0; i < data.length; i++) {
          List<dynamic> list = data[i];
          if (list != null && list.isNotEmpty) {
            RentList rentList;
            ItemType itemType = list[0];
            if (itemType == ItemType.title_my_lessor_list ||
                itemType == ItemType.title_others_lessor_list) {
              //subTitle
              rentList = new RentList(itemType: list[0]);
            } else {
              String tokenId = list[1].toString();
              String lessor;
              String tenant;
              if (itemType == ItemType.my_lessor_list) {
                lessor = list[2].toString();
              } else {
                tenant = list[2].toString();
              }
              String leasingSchedule = list[3].toString();
              String leasingTime = list[4].toString();
              double nftValue =
                  EtherAmount
                      .fromUnitAndValue(EtherUnit.kwei, list[5])
                      .getInEther
                      .toDouble() /
                      1000;
              double securityDeposit =
                  EtherAmount
                      .fromUnitAndValue(EtherUnit.kwei, list[6])
                      .getInEther
                      .toDouble() /
                      1000;
              double rent =
                  EtherAmount
                      .fromUnitAndValue(EtherUnit.kwei, list[7])
                      .getInEther
                      .toDouble() /
                      1000;
              rentList = new RentList(
                  itemType: list[0],
                  tokenId: tokenId,
                  lessor: lessor,
                  tenant: tenant,
                  leasingSchedule: leasingSchedule,
                  leasingTime: leasingTime,
                  nftValue: nftValue,
                  securityDeposit: securityDeposit,
                  rent: rent);
            }
            lessorList.add(rentList);
          }
        }
        if (lessorList != null) {
          if (mounted) {
            setState(() {});
          }
        }
      }
    });
  }

  Future<void> _pullToRefresh() async {
    await getLessorList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullToRefresh,
      child: Scaffold(
        body: buildListView(),
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
      ),
    );
  }

  Widget buildListView() {
    if (lessorList == null) {
      getLessorList();
      return Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      );
    }
    if (lessorList.length == 0) {
      return CommonUIUtils.buildListViewEmpty();
    }
    return ListView.builder(
        padding: EdgeInsets.all(0.0),
        itemBuilder: (context, index) {
          RentList rentList = lessorList[index];
          if (rentList.itemType == ItemType.title_my_lessor_list) {
            //subtitle
            return CommonUIUtils.buildSubTitle('My lessor list');
          } else if (rentList.itemType == ItemType.title_others_lessor_list) {
            //subtitle
            return CommonUIUtils.buildSubTitle('Others lessor list');
          }
          return Container(
            child: GestureDetector(
              child: Row(
                children: <Widget>[
                  CommonUIUtils.buildImage(index),
                  buildColumn(rentList)
                ],
              ),
              onTap: () {
                //弹出对话框
                showDialog(
                  context: context,
                  builder: (context) {
                    //receiving orders
                    if (rentList.itemType == ItemType.others_tenant_list) {
                      return CommonUtils.commonDialog(
                          context, null, 'Are you sure to receive the order?',
                              () {
                            ContractUtils.receiptByLessor(rentList.tokenId)
                                .then((result) {
                              if (result != null) {
                                CommonUtils.showToast(
                                    context,
                                    'send transaction success,please wait');
                              }
                            });
                          });
                    }
                    //withdraw the NFT
                    return CommonUtils.commonDialog(
                        context, null, ' Are you sure to withdraw the NFT?',
                            () {
                          ContractUtils.withdrawlByLessor(rentList.tokenId)
                              .then((result) {
                            if (result != null) {
                              CommonUtils.showToast(
                                  context,
                                  'send transaction success,please wait');
                            }
                          });
                        });
                  },
                );
              },
            ),
            decoration: CommonUIUtils.buildBoxDecorationBottom(),
          );
        },
        itemCount: lessorList.length);
  }

  Expanded buildColumn(RentList rentList) {
    String tokenId = 'tokenID:${rentList.tokenId}';
    String address = rentList.itemType == ItemType.my_lessor_list
        ? 'lessor:${rentList.lessor}'
        : 'tenant:${rentList.tenant}';
    String leasingSchedule = 'leasingSchedule:${rentList.leasingSchedule}';
    String leasingTime = 'leasingTime:${rentList.leasingTime}';
    String nftValue = 'nftValue:${rentList.nftValue.toString()}ETH';
    String securityDeposit =
        'securityDeposit:${rentList.securityDeposit.toString()}ETH';
    String rent = 'rent:${rentList.rent.toString()}ETH';

    //Expanded只能在Row、Column等组件内使用
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          /**
           * mainAxisAlignment：主轴布局方式，column主轴方向是垂直的方向
           * crossAxisAlignment: 交叉轴的布局方式，对于column来说就是水平方向的布局方式
           * https://www.jianshu.com/p/1d003ab6c278
           */
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildRow(tokenId, rent),
            buildRow(leasingSchedule, leasingTime),
            buildRow(nftValue, securityDeposit),
            Container(
                margin: EdgeInsets.only(top: 5.0),
                child: CommonUIUtils.buildText(address))
          ],
        ),
      ),
    );
  }

  Container buildRow(String value1, String value2) {
    return Container(
        margin: EdgeInsets.only(top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CommonUIUtils.buildText(value1),
            Container(
              child: CommonUIUtils.buildText(value2),
              margin: EdgeInsets.only(left: 10.0),
            )
          ],
        ));
  }
}
