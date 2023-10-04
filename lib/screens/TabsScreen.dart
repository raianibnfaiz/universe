import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universe/screens/BreakingFeed.dart';
import 'package:universe/screens/home.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {

  int _selectedPageIndex = 0;
  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget activePage =  BreakingFeed();
    var activeTitle = "News Feed";
    if(_selectedPageIndex == 1){
      activePage =  ProfileScreen();
      activeTitle = "My Profile";
    }
    return Scaffold(
      appBar: AppBar(
        title:  Text(activeTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
