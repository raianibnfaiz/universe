
import 'package:flutter/material.dart';
import 'package:universe/screens/home.dart';


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
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
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
