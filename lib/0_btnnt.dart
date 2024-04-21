import 'package:swapitem/10_chat.dart';

import '9_my_profile.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';

import 'notification_page.dart';

class btnnt extends StatefulWidget {
  final List<String>? filter;
  final String? searchString;
  const btnnt({Key? key, this.searchString, this.filter}) : super(key: key);

  @override
  State<btnnt> createState() => _btnntState();
}

class _btnntState extends State<btnnt> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions(BuildContext context, String? searchString, List<String>? filter) {
    return [
      HomePage(searchString: searchString, filter: filter),
      ChatHomePage(),
      NotificationD(),
      Profile(),
    ];
  }

  static const List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'หน้าแรก',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: 'แชท',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications_active),
      label: 'แจ้งเตือน',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'ข้อมูลส่วนตัว',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _widgetOptions(context, widget.searchString, widget.filter).elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: _bottomNavBarItems,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}



