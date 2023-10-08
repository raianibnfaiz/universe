import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universe/screens/BreakingFeed.dart';
import 'package:universe/screens/ProfileScreen.dart';

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
  void initState() {
    super.initState();
    _getUserInfo();
  }
  Future<void> _getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'username': user?.displayName,
        'email': user?.email,
        'image_url': user.photoURL != null? user?.photoURL: 'https://t3.ftcdn.net/jpg/01/18/06/32/360_F_118063283_FD6CvzN1v1LFEMupsqEfuOkPbfjuO0CU.jpg'

      });
    }
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
