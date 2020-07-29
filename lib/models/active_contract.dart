import 'package:client/utils/data_utils.dart';

class ActiveContract {
  String tokenId;

  String lessor;

  String tenant;

  String leasingSchedule;

  int startTime;

  int lastTime;

  var securityDeposit;

  var rent;


  var leasingTime;

  var payCount;

  var balance;



  ActiveContract({
    this.tokenId,
    this.lessor,
    this.tenant,
    this.leasingSchedule,
    this.startTime,
    this.lastTime,
    this.securityDeposit,
    this.rent,
    this.leasingTime,
    this.payCount,
    this.balance
  });
}