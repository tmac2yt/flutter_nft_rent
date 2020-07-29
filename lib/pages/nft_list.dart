import 'package:client/constants/event_bus.dart';
import 'package:client/pages/claim_nft.dart';
import 'package:client/utils/common_ui_utils.dart';
import 'package:client/utils/common_utils.dart';
import 'package:client/utils/contract_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class NFTList extends StatefulWidget {
  @override
  _NFTListState createState() => _NFTListState();
}

class _NFTListState extends State<NFTList> {
  int curPage = 1;
  List nftList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<GenerateNFTEvent>().listen((event) {
      getNFT();
    });
    eventBus.on<LoginEvent>().listen((event) {
      getNFT();
    });
  }

  getNFT() async {
    await ContractUtils.getNFT().then((data) {
      if (data != null) {
        print(data);
        nftList = data[0];
        if (nftList != null) {
          if (mounted) {
            setState(() {});
          }
        }
      }
    });
  }

  Future<void> _pullToRefresh() async {
    await getNFT();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullToRefresh,
      child: Scaffold(
        body: buildListView(),
        appBar: AppBar(
          title: Text('Your NFT'),
          elevation: 0.0,
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ClaimNFT()));
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
    if (nftList == null) {
      getNFT();
      return Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      );
    }
    if (nftList.length == 0) {
      return CommonUIUtils.buildListViewEmpty();
    }

    return ListView.separated(
        itemBuilder: (context, index) {
          String titleStr = 'tokenID = ' + nftList[index].toString();
          return Container(
            child: Row(
              children: <Widget>[
                CommonUIUtils.buildImage(index),
                Container(
                  child: CommonUIUtils.richTextWidget(
                      'tokenId', nftList[index].toString()),
                  margin: EdgeInsets.only(left: 10.0),
                ),
              ],
            ),
            margin: EdgeInsets.only(left: 10.0, top: 5.0),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.blueGrey,
          );
        },
        itemCount: nftList.length);
  }
}
