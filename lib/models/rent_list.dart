import 'package:client/utils/data_utils.dart';

class RentList {
  ItemType itemType;

  String tokenId;

  String lessor;

  String tenant;

  String leasingSchedule;

  String leasingTime;

  var nftValue;

  var securityDeposit;

  var rent;

  RentList({
    this.itemType,
    this.tokenId,
    this.lessor,
    this.tenant,
    this.leasingSchedule,
    this.leasingTime,
    this.nftValue,
    this.securityDeposit,
    this.rent
  });
}