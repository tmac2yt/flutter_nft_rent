import 'package:client/utils/common_utils.dart';
import 'package:client/utils/contract_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClaimNFT extends StatefulWidget {
  @override
  _ClaimNFTState createState() => _ClaimNFTState();
}

class _ClaimNFTState extends State<ClaimNFT> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (myController != null) {
      myController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('claim free nft'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              controller: myController,
              maxLength: 3,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  icon: Text(
                    'Token ID',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  labelText: 'input 3-digit token ID'),
            ),
            Align(
              child: MaterialButton(
                onPressed: () {
                  String tokenId = myController.text;
                  if (tokenId != null && tokenId.length == 3) {
                    ContractUtils.isNFTExist(tokenId).then((result) {
                      if (result) {
                        CommonUtils.showToast(context, 'this nft exist');
                      } else {
                        ContractUtils.generateNFT(tokenId).then((result) {
                          if (result != null) {
                            CommonUtils.showToast(context,
                                'send transaction success,please wait');
                          }
                        });
                      }
                    });
                  }
                },
                child: Text('Claim'),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
