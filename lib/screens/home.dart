
import 'package:flutter/material.dart';
import 'package:universe/screens/login.dart';
import 'package:universe/services/firebase_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Home"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            FirebaseServices().signout();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          child: const Text('Logout'),
        )
      ),
    );
  }
}
