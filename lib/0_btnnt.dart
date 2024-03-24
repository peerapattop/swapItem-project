import 'package:swapitem/10_chat.dart';

import '9_my_profile.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';

import 'notification_page.dart';

class btnnt extends StatefulWidget {
  const btnnt({super.key});

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

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ChatHomePage(),
    NotificationD(),
    Profile(),
  ];

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
      icon: Icon(Icons.notification_add),
      label: 'แจ้งเตือน',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'ข้อมูลส่วนตัว',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}


