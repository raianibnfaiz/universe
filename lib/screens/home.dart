import 'package:flutter/material.dart';
import 'package:universe/screens/AuthScreen.dart';
import 'package:universe/screens/login.dart';
import 'package:universe/services/firebase_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            FirebaseServices().signout();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AuthScreen()));
          },
          child: const Text('Logout'),
        )
      ),
    );
  }
}
