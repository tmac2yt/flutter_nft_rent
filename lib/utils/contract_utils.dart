import 'dart:async';

import 'package:client/constants/event_bus.dart';
import 'package:client/utils/common_utils.dart';
import 'package:client/utils/data_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractUtils {
  static String privateKey;
//      'b7f17be35ed23a376efc826d3c4db1ca5de03ce2eefad03f6949bd922326ee8a';

  static const String erc721_contract_address =
      "0x898f6921bbf897be9572df299c5fe77b0418e252";
  static const String rent_contract_address =
      "0x17df3a6ce08a6ef9837ab80170887171b7d7914d";

  static const String rpcUrl =
      'https://ropsten.infura.io/v3/f250163948cc4193ba4a3b60039c5660';
  static const String wsUrl =
      'ws://ropsten.infura.io/v3/f250163948cc4193ba4a3b60039c5660';

  static DeployedContract erc721Contract;
  static DeployedContract rentContract;
  static Web3Client client;
  static EthereumAddress ownAddress;
  static bool isInitialized = false;
  static Credentials credentials;

  //保存登录信息
  static Future<void> initContracts(BuildContext context) async {
    // establish a connection to the ethereum rpc node. The socketConnector
    // property allows more efficient event streams over websocket instead of
    // http-polls. However, the socketConnector property is experimental.
    client = Web3Client(rpcUrl, http.Client(), socketConnector: () {
      //reason:https://github.com/simolus3/web3dart/issues/37
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
    credentials = await client.credentialsFromPrivateKey(privateKey);
    ownAddress = await credentials.extractAddress();
    // read the contract abi and tell web3dart where it's deployed (contractAddr)
//    final File rentAbiFile =
//        File(join(dirname(Platform.script.path), 'rent_abi.json'));

    final rentAbiCode = await DefaultAssetBundle.of(context)
        .loadString("assets/data/rent_abi.json");
    final EthereumAddress rentContractAddress =
        EthereumAddress.fromHex(rent_contract_address);
    rentContract = DeployedContract(
        ContractAbi.fromJson(rentAbiCode, 'NFTRent'), rentContractAddress);
//    final File erc721AbiFile =
//        File(join(dirname(Platform.script.path), 'erc721_abi.json'));

    final erc721AbiCode = await DefaultAssetBundle.of(context)
        .loadString("assets/data/erc721_abi.json");
    final EthereumAddress erc721ContractAddress =
        EthereumAddress.fromHex(erc721_contract_address);
    erc721Contract = DeployedContract(
        ContractAbi.fromJson(
            erc721AbiCode.toString(), 'StandardAssetRegistryTest'),
        erc721ContractAddress);
    isInitialized = true;
    initEvents();
  }

  static Future<List> getNFT() async {
    List<dynamic> result =
        await callContract(erc721Contract, 'tokensOf', [ownAddress]);
    return result;
  }

  static Future<bool> isNFTExist(String tokenId) async {
    BigInt bigInt = BigInt.parse(tokenId);
    List<dynamic> result =
        await callContract(erc721Contract, 'exists', [bigInt]);
    if (result != null && result.isNotEmpty) {
      return result[0];
    }
    return true;
  }

  //获取所有的租客挂单（包括自己的出租挂单，因为允许撤回）
  static Future<List> getLessorList() async {
    List<dynamic> result =
        await callContract(rentContract, 'getMyRentListIndexes', []);
    List<List<dynamic>> lessorList = new List();
    if (result != null && result.isNotEmpty) {
      print(result);
      List<dynamic> tokenIdList = result[0];
      if (tokenIdList != null && tokenIdList.length > 0) {
        //subtitle mark
        List<dynamic> subTitle = List();
        subTitle.add(ItemType.title_my_lessor_list);
        lessorList.add(subTitle);
        for (int i = 0; i < tokenIdList.length; i++) {
          List<dynamic> lessor = await callContract(
              rentContract, 'getLessorList', [tokenIdList[i]]);
          lessor.insert(0, tokenIdList[i]);
          lessor.insert(0, ItemType.my_lessor_list);
          lessorList.add(lessor);
        }
        print(lessorList);
      }
    }
    return getOtherTenantList(lessorList);
  }

  //获取出租者的挂单（不包括自己的出租挂单）
  static Future<List> getOtherTenantList(
      List<List<dynamic>> lessorList) async {
    List<dynamic> result =
        await callContract(rentContract, 'getOtherTenantTokenIdList', []);
    if (result != null && result.isNotEmpty) {
      print(result);
      List<dynamic> tokenIdList = result[0];
      if (tokenIdList != null && tokenIdList.length > 0) {
        //subtitle mark
        List<dynamic> subTitle = List();
        subTitle.add(ItemType.title_others_lessor_list);
        lessorList.add(subTitle);
        for (int i = 0; i < tokenIdList.length; i++) {
          List<dynamic> lessor = await callContract(
              rentContract, 'getTenantList', [tokenIdList[i]]);
          lessor.insert(0, tokenIdList[i]);
          lessor.insert(0, ItemType.others_tenant_list);
          lessorList.add(lessor);
        }
        print(lessorList);
      }
    }
    return lessorList;
  }



  static Future<List> getActiveContractList() async {
    List<dynamic> result =
    await callContract(rentContract, 'getMyRentListIndexes', []);
    List<List<dynamic>> activeContractList = new List();
    if (result != null && result.isNotEmpty) {
      print('$result');
      List<dynamic> tokenIdList = result[0];
      if (tokenIdList != null && tokenIdList.length > 0) {
        for (int i = 0; i < tokenIdList.length; i++) {
          List<dynamic> activeContract = await callContract(
              rentContract, 'getRentList', [tokenIdList[i]]);
          activeContractList.add(activeContract);
        }
        print(activeContractList);
      }
    }
    return activeContractList;
  }

  static Future<List> callContract(
      DeployedContract contract, String funcName, List<dynamic> params) async {
    if (contract != null && client != null && ownAddress != null) {
      final func = contract.function(funcName);
      List<dynamic> list =
          await client.call(contract: contract, function: func, params: params);
      return list;
    }
  }

  static Future<String> generateNFT(String tokenId) async {
    List<dynamic> params = new List();
    params.add(BigInt.parse(tokenId));
    params.add(ownAddress);
    return await sendTransaction(erc721Contract, 'generate', params);
  }

  static Future<String> receiptByLessor(String tokenId) async {
    List<dynamic> params = new List();
    params.add(BigInt.parse(tokenId));
    return await sendTransaction(rentContract, 'receiptByLessor', params);
  }

  static Future<String> withdrawlByLessor(String tokenId) async {
    List<dynamic> params = new List();
    params.add(BigInt.parse(tokenId));
    return await sendTransaction(rentContract, 'withdrawlByLessor', params);
  }

  static Future<String> listByLessor(
      String tokenId,
      int nftValue,
      String leasingSchedule,
      String leasingTime,
      int securityDeposit,
      int rent) async {
    List<dynamic> params = new List();
    params.add(ownAddress);
    params.add(BigInt.parse(tokenId));
    BigInt nftValueBI = EtherAmount.fromUnitAndValue(EtherUnit.finney,nftValue).getInWei;
    params.add(nftValueBI);
    params.add(leasingSchedule);
    params.add(BigInt.parse(leasingTime));
    BigInt securityDepositBI = EtherAmount.fromUnitAndValue(EtherUnit.finney,securityDeposit).getInWei;
    params.add(securityDepositBI);
    BigInt rentBI = EtherAmount.fromUnitAndValue(EtherUnit.finney,rent).getInWei;
    params.add(rentBI);
    print(params);
    return await sendTransaction(rentContract, 'listByLessor', params);
  }

  static Future<String> sendTransaction(
      DeployedContract contract, String funcName, List<dynamic> params) async {
    if (contract != null && client != null && ownAddress != null) {
      final func = contract.function(funcName);
      try {
        String result = await client.sendTransaction(
          credentials,
          Transaction.callContract(
            contract: contract,
            function: func,
            parameters: params,
            gasPrice: EtherAmount.inWei(BigInt.from(10000)),
            maxGas: 1000000,
          ),
          fetchChainIdFromNetworkId: true,
        );
        print('sendTransaction_result=$result');
        return result;
      } catch (e) {
        print(e);
        return null;
      }
    }
  }

  static void initEvents() async {
    //listen ntf generate success
    final transferEvent = erc721Contract.event('Transfer');
    StreamSubscription subscription = client
        .events(FilterOptions.events(
            contract: erc721Contract, event: transferEvent))
        .take(1)
        .listen((event) {
      print('generate success');
      eventBus.fire(GenerateNFTEvent);
    });
    await subscription.asFuture();
    await subscription.cancel();
  }

  static Future<void> destroy() async {
//    await subscription.asFuture();
//    await subscription.cancel();
    await client.dispose();
  }

  static String getAccountAddress(){
    if(ownAddress != null){
      return ownAddress.toString();
    }
    return null;
  }
}
