import 'package:client/utils/common_ui_utils.dart';
import 'package:client/utils/common_utils.dart';
import 'package:client/utils/contract_utils.dart';
import 'package:client/widgets/simple_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LessorOrder extends StatefulWidget {
  @override
  _LessorOrderState createState() => _LessorOrderState();
}

class _LessorOrderState extends State<LessorOrder> {
  final tokenIdController = TextEditingController();
  final nftValueController = TextEditingController();
  final leasingTimeController = TextEditingController();
  final amountController = TextEditingController();
  final securityDepositController = TextEditingController();
  final List<String> leasingTimeData = ['minute', 'daily', 'weekly', 'monthly'];
  String leasingSchedule;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (tokenIdController != null) {
      tokenIdController.dispose();
    }
    if (nftValueController != null) {
      nftValueController.dispose();
    }
    if (leasingTimeController != null) {
      leasingTimeController.dispose();
    }
    if (amountController != null) {
      amountController.dispose();
    }
    if (securityDepositController != null) {
      securityDepositController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lessor place order'),
      ),
      //解决flutter键盘弹起出错的问题：用SingleChildScrollView包裹
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: TextField(
                  controller: tokenIdController,
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Text(
                      'Token ID',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    labelText: 'input 3-digit token ID',
                    border: InputBorder.none,
                  ),
                ),
                decoration: CommonUIUtils.buildBoxDecorationBottom(),
              ),
              Container(
                child: TextField(
                  controller: nftValueController,
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[0-9.]"))
                  ],
                  decoration: InputDecoration(
                    icon: Text(
                      'NFT value(ETH)',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    labelText: 'input NFT value',
                    border: InputBorder.none,
                  ),
                ),
                decoration: CommonUIUtils.buildBoxDecorationBottom(),
              ),
              Container(
                height: 60.0,
                child: Row(
                  children: <Widget>[
                    Text('Leasing Schedule'),
                    FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              child: SimpleListDialog(
                                dataList: leasingTimeData,
                                onItemClickListener: (data) {
                                  if (data != 'minute') {
                                    CommonUtils.showToast(context,
                                        'At present, it only supports minute');
                                    return false;
                                  }
                                  leasingSchedule = data;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  return true;
                                },
                              ));
                        },
                        child: Text(
                          leasingSchedule ?? '',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ))
                  ],
                ),
                decoration: CommonUIUtils.buildBoxDecorationBottom(),
              ),
              Container(
                child: TextField(
                  controller: leasingTimeController,
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Text(
                      'Leasing Time( X 10 minutes)',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    labelText: 'input Leasing Time',
                    border: InputBorder.none,
                  ),
                ),
                decoration: CommonUIUtils.buildBoxDecorationBottom(),
              ),
              Container(
                child: TextField(
                  controller: amountController,
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[0-9.]"))
                  ],
                  decoration: InputDecoration(
                    icon: Text(
                      'Amount (every 10 minutes in ETH)',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    labelText: 'input Amount',
                    border: InputBorder.none,
                  ),
                ),
                decoration: CommonUIUtils.buildBoxDecorationBottom(),
              ),
              Container(
                child: TextField(
                  controller: securityDepositController,
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[0-9.]"))
                  ],
                  decoration: InputDecoration(
                    icon: Text(
                      'securityDeposit',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    labelText: 'input securityDeposit',
                    border: InputBorder.none,
                  ),
                ),
                decoration: CommonUIUtils.buildBoxDecorationBottom(),
              ),
              Align(
                child: MaterialButton(
                  onPressed: () {
                    String tokenId = tokenIdController.text;
                    String nftValue = nftValueController.text;
                    String leasingTime = leasingTimeController.text;
                    String amount = amountController.text;
                    String securityDeposit = securityDepositController.text;
                    if (tokenId != null &&
                        tokenId.isNotEmpty &&
                        nftValue != null &&
                        nftValue.isNotEmpty &&
                        leasingSchedule != null &&
                        leasingSchedule.isNotEmpty &&
                        leasingTime != null &&
                        leasingTime.isNotEmpty &&
                        amount != null &&
                        amount.isNotEmpty &&
                        securityDeposit != null &&
                        securityDeposit.isNotEmpty) {
                      int nftValueInt =
                          (double.tryParse(nftValue) * 1000).toInt();
                      int amountInt = (double.tryParse(amount) * 1000).toInt();
                      int securityDepositInt =
                          (double.tryParse(securityDeposit) * 1000).toInt();
                      ContractUtils.listByLessor(
                              tokenId,
                              nftValueInt,
                              leasingSchedule,
                              leasingTime,
                              securityDepositInt,
                              amountInt)
                          .then((result) {
                        if (result != null) {
                          CommonUtils.showToast(
                              context, 'send transaction success,please wait');
                        }
                      });
                    } else {
                      CommonUtils.showToast(context, 'please check your input');
                    }
                  },
                  child: Text('Place Order'),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
