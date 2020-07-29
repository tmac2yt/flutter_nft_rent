import 'package:client/constants/constants.dart';
import 'package:client/constants/event_bus.dart';
import 'package:client/pages/active_contract_list.dart';
import 'package:client/pages/lessee_list.dart';
import 'package:client/pages/lessor_list.dart';
import 'package:client/pages/nft_list.dart';
import 'package:client/utils/contract_utils.dart';
import 'package:client/utils/data_utils.dart';
import 'package:client/widgets/my_drawer.dart';
import 'package:client/widgets/navigation_icon_view.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _appTitle = ['nft', 'lessor', 'lessee', 'contract'];
  final _menuIcons = [Icons.favorite, Icons.home, Icons.group, Icons.settings];
  final _menuTitles = ['Crypto Kitty', 'Decentraland', 'about us', 'settings'];
  List<NavigationIconView> _navigationIconViews;
  var _currentIndex = 0;
  List<Widget> _pages;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigationIconViews = [
      NavigationIconView(
          title: _appTitle[0],
          iconPath: 'assets/images/ic_nav_news_normal.png',
          activeIconPath: 'assets/images/ic_nav_news_actived.png'),
      NavigationIconView(
          title: _appTitle[1],
          iconPath: 'assets/images/ic_nav_tweet_normal.png',
          activeIconPath: 'assets/images/ic_nav_tweet_actived.png'),
      NavigationIconView(
          title: _appTitle[2],
          iconPath: 'assets/images/ic_nav_discover_normal.png',
          activeIconPath: 'assets/images/ic_nav_discover_actived.png'),
      NavigationIconView(
          title: _appTitle[3],
          iconPath: 'assets/images/ic_nav_my_normal.png',
          activeIconPath: 'assets/images/ic_nav_my_pressed.png')
    ];

    _pages = [NFTList(), LessorList(), LesseeList(), ActiveContractList()];

    _pageController = PageController(initialPage: _currentIndex);

    DataUtils.getPrivateKey().then((privateKey) {
      if (privateKey != null && privateKey.isNotEmpty) {
        ContractUtils.privateKey = privateKey;
        ContractUtils.initContracts(context).then((_) {
          if (mounted) {
            setState(() {});
            eventBus.fire(LoginEvent());
          }
        });
      }
    });

    eventBus.on<LoginEvent>().listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //SafeArea 可以适配刘海屏等异性屏
    return Scaffold(
//      appBar: AppBar(
//        elevation: 0.0,
//        title: Text('Decentralized NFT leasing protocol'),
//        //title bar icon颜色
//        iconTheme: IconThemeData(color: Color(AppColors.APPBAR)),
//      ),
      body: PageView.builder(
        //禁止滑动
//        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _pages[index];
        },
        controller: _pageController,
        itemCount: _pages.length,
        //设置滑动切换页面
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _navigationIconViews.map((view) => view.item).toList(),
        //不设置type，底部导航不显示
        type: BottomNavigationBarType.fixed,
        //设置点击切换页面
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: Duration(microseconds: 1), curve: Curves.ease);
        },
      ),
      drawer: MyDrawer(
          headImagePath: 'assets/images/cover_img.jpg',
          menuTitles: _menuTitles,
          menuIcons: _menuIcons),
    );
  }
}
