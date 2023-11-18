import 'package:swapitem/10_chat.dart';

import '9_my_pro.dart';
import '2_home_page.dart';
import 'package:flutter/material.dart';

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
    Chat(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'หน้าแรก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'แชท',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'ข้อมูลส่วนตัว',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
