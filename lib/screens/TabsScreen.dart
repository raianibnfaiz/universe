import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universe/screens/BreakingFeed.dart';
import 'package:universe/screens/ProfileScreen.dart';

import '../widgets/EditProfile.dart';

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
    final docs = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email);

    if (docs == null) {
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'username': user?.displayName,
        'email': user?.email,
        'image_url': user?.photoURL != null? user?.photoURL: 'https://t3.ftcdn.net/jpg/01/18/06/32/360_F_118063283_FD6CvzN1v1LFEMupsqEfuOkPbfjuO0CU.jpg'

      });
    }
  }
  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: Container(
            child: NewExpense(
              onClose: () {
                Navigator.of(context).pop();
              },
            ),
        ),
        );
      },
    );
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
        actions: (_selectedPageIndex == 1)?[
        IconButton(
            icon: const Icon(Icons.mode_edit_outline_rounded),
            onPressed: _openAddExpensesOverlay,
          )
        ]:[],
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
