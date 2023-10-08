import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universe/screens/TabsScreen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
            onPressed: () async{
              await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
                'username': user?.displayName,
                'email': user?.email,
                'image_url': user?.photoURL,
              });
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TabsScreen()));
            },
            child: const Text('Home'),
          )
      ),
    );
  }
}