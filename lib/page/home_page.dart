import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/data/api/api_service.dart';
import 'package:flutter_application_1/page/favourite_page.dart';
import 'package:flutter_application_1/page/restaurant_list.dart';
import 'package:flutter_application_1/page/setting_page.dart';
import 'package:flutter_application_1/provider/restaurant_provider.dart';
import 'package:flutter_application_1/utils/notification_helper.dart';
import 'package:flutter_application_1/widget/platform.dart';
import 'dart:io';
import 'package:flutter_application_1/page/restaurant_detail.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final NotificationHelper _notificationHelper = NotificationHelper();


  void initState() {
    super.initState();
  
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  int _bottomNavIndex = 0;
  static const String _headlineText = 'List';
  static const String _headLineText2 = 'Search';
  final List<Widget> _listWidget = [
    RestaurantListPage(),
    FavouritePage(),
    SettingsPage()
  ];

  List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.list_bullet : Icons.list),
      label: _headlineText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.search : Icons.favorite),
      label: "Favourite",
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.search : Icons.alarm),
      label: "Alarm",
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: _bottomNavBarItems),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
