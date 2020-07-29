# 基于以太坊的ERC-721资产的租赁平台

## 💡 项目背景
Oort Digital正在开发一个NFT租赁的去中心化协议，实现NFT全球化租赁，增加NFT流动性，促进构建一个完善的NFT估值体系



## 🏠 关于Oort Digital
https://5f0246cc0f70ad0008eb2754--romantic-goldstine-1d74b6.netlify.app



## 🏹 功能描述
举一个例子：

Alice 拥有一个NFT，想要租赁获得被动收益，她的个人钱包地址为A。
Bob想要用ETH租赁这个NFT，他的个人钱包地址为B。
智能合约地址为C。

Alice 首先需要挂单，假设她对NFT的估值是10ETH，APR为12%，租期为10个月，选择月租，则每月租金为 1 ETH =（10 ETH* (12%/12) * 10个月）, 总共在10个月内的ROI为 （1ETH * 10 个月）/10ETH = 100%。押金 security deposit 假如设置0.5 ETH。月租金在月底付。

Alice 设置好挂单操作后，点击 “Deposit” 便可以把该NFT从地址 A 转到合约地址 C。此时C 从 状态0 进入到状态 1。 在状态1， Alice 随时可以把NFT “withdrawl” 回自己的地址 A。 当然 Bob 也可以先挂单，等待 Alice接单，原理相同。

Bob 看到了Alice 的挂单，决定点击接单。在Bob点击接单时，押金 0.5 ETH 自动从地址B 到 C。合约地址C进入状态2。在状态2，Alice无法用地址A去使用该NFT，而Bob可以用地址B去使用该NFT。在状态2，合约地址C会在每个月月底自动往地址A发送 1 ETH。Bob 可以随时往合约地址C打任何数量的ETH，也随时可以取出任何数量ETH,只需要保证在每个月月底C需要发送给A时，有至少1 ETH，否则属于违约。一旦发生违约，合约进入状态3,  0.5个ETH以及该NFT会重新从C转到A，合约回归到状态0.




## 🧩 技术架构
### 1.区块链
在以太坊测试链上（Ropsten）部署了两个智能合约：
- 1.自定义的ERC721合约：StandardAssetRegistryTest.sol
合约地址：0x898f6921bbf897be9572df299c5fe77b0418e252

- 2.NFT租赁合约：NFTRNET.sol
合约地址：0xe60ec887223098a5514d6ae1d7eb7633338c23e9

- 项目链接：https://github.com/oort-digital/nft_rent

  

### 2.服务器端
- 框架：springBoot + web3.java

- 项目链接：https://github.com/oort-digital/nft-rent-contracts

  

### 3.前端
- 框架：bootStrap + jquery + web3.js + walletConnect

- 项目链接：https://github.com/oort-digital/landing

  

### 4.app
#### 框架：flutter + web3dart
#### Features
- 1.支持扫描登录以太坊账户

- 2.访问ERC721和租赁合约方法

- 3.调用ERC721和租赁合约发送交易

- 4.监听ERC721和租赁合约状态，实时更新数据

- 5.分为四大业务模块：
    NFT资产，出租NFT,租赁NFT,已达成的NFT租赁
    
    

#### app截图
![](https://github.com/15088518315/flutter_nft_rent/blob/master/screenshorts/app.jpg)
![](https://github.com/15088518315/flutter_nft_rent/blob/master/screenshorts/login.jpg)
![](https://github.com/15088518315/flutter_nft_rent/blob/master/screenshorts/logined.jpg)
![](https://github.com/15088518315/flutter_nft_rent/blob/master/screenshorts/nft.jpg)
![](https://github.com/15088518315/flutter_nft_rent/blob/master/screenshorts/lessor_list.jpg)
![](https://github.com/15088518315/flutter_nft_rent/blob/master/screenshorts/lessor_order.jpg)
![](https://github.com/15088518315/flutter_nft_rent/blob/master/screenshorts/active_contract.jpg)
![](https://github.com/15088518315/flutter_nft_rent/blob/master/screenshorts/active_contract_detail.jpg)
![](https://github.com/15088518315/flutter_nft_rent/blob/master/screenshorts/about_us.jpg)
![](https://github.com/15088518315/flutter_nft_rent/blob/master/screenshorts/crypto_kitty.jpg)
![](https://github.com/15088518315/flutter_nft_rent/blob/master/screenshorts/land.jpg)
