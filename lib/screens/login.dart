
import 'package:flutter/material.dart';
import 'package:universe/screens/ProfileScreen.dart';
import 'package:universe/services/firebase_services.dart';

import 'TabsScreen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
        body: Center(
          child: FloatingActionButton.extended(
            onPressed: () async {
              await FirebaseServices().signInWithGoogle();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TabsScreen()));
            },
            icon: const Icon(Icons.login),
            label: Text("Sign In With Google"),
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,

          ),
          //buildLoginButton(),
        ));
  }
}
/*
FloatingActionButton buildLoginButton() {
  return FloatingActionButton.extended(
    onPressed: () {
      Navigator.push(context as BuildContext,
          MaterialPageRoute(builder: (context) => HomeScreen()));
    },
    icon: const Icon(Icons.login),
    label: Text("Sign In With Google"),
    foregroundColor: Colors.white,
    backgroundColor: Colors.black,

  );
}*/
