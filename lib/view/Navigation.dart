import 'package:flutter/material.dart';
import 'package:study_app/assets/MyColors.dart';
import 'package:study_app/view/HomeScreen.dart';
import 'package:study_app/view/SettingScreen.dart';
import 'package:study_app/view/TestScreen.dart';

class Navigation extends StatefulWidget {
  final int initialIndex;
  const Navigation({super.key, required this.initialIndex});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _widgetOptions = <Widget>[
      const HomeScreen(),
      const TestScreen(),
      const SettingScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: Center(
          child: IndexedStack(
            index: _selectedIndex,
            children: _widgetOptions,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: MyColors.backgroundColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.home
              ),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.menu_book
              ),
              label: 'Kiểm tra',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  Icons.settings
              ),
              label: 'Cài đặt',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.yellow,
          unselectedItemColor: Colors.white70,
          onTap: _onItemTapped,
        )
    );
  }
}
