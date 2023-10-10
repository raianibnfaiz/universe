import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universe/screens/edit_profile.dart';
import 'package:universe/widgets/user_image_picker.dart';

import '../services/firebase_services.dart';
import 'TabsScreen.dart';


const kPrimaryColor = Color(0xFF00ACC1);

final TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16.0,
);

final TextStyle kLabelTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

final _auth = FirebaseAuth.instance;
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final form = GlobalKey<FormState>();
  User? user = _auth.currentUser;
  var _isLogin = true;
  var _isGoogleSignIn = false;
  var enteredEmail = '';
  var enteredPassword = '';
  var enteredUsername = '';
  File? _selectedImage;
  final _isAuthenticating = false;
  void _submit() async{
    final isValid = form.currentState!.validate();
    if(isValid){
      form.currentState!.save();
    }
    if(!isValid || _selectedImage == null && !_isLogin){
      return;
    }
    if(_isLogin){
      // Log user in
      try{
        if(_isLogin){
          final userCredential = await _auth.signInWithEmailAndPassword(email: enteredEmail, password: enteredPassword);
          print(userCredential);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TabsScreen()),
          );
        }

      }on FirebaseAuthException catch(error){
        /*if(error.code=='email-already-in-use') {
          print('The account already exists for that email.');
        }*/
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'The account already exists for that email.'),
          ),
        );
        print('error');
      }

    }
    if(!_isLogin){
      // Sign user up
      try{
        final userCredential = await _auth.createUserWithEmailAndPassword(email: enteredEmail, password: enteredPassword);
        final storageRef = FirebaseStorage.instance.ref('user_image').child(userCredential.user!.uid + '.jpg');
        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': enteredUsername,
          'email': enteredEmail,
          'image_url': await storageRef.getDownloadURL(),
          'phone': '',
          'division': null,
          'district': null,
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TabsScreen()),
        );
        print("Image URL $imageUrl");
        print(userCredential);
      }on FirebaseAuthException catch(error){
        /*if(error.code=='email-already-in-use') {
          print('The account already exists for that email.');
        }*/
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'The account already exists for that email.'),
          ),
        );
      }
    }
    /*if(_isGoogleSignIn){
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'username': user?.displayName,
        'email': user?.email,
        'image_url': user?.photoURL,
      });
    }
*/


    print(enteredEmail);
    print(enteredPassword);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Image.asset(
                  'assets/images/scoop_insight.png',
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),

                  child: Form(
                    key: form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColoredBox(color: Colors.white),
                        if(!_isLogin)

                          UserImagePicker(onPickimage: (pickedImage){
                            _selectedImage = pickedImage;
                          },),
                        if(!_isLogin)
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Username'),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return 'Username myst be at least 4 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value){
                              enteredUsername = value!;
                            },
                          ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value){
                            enteredEmail = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Password must be at least 6 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value){
                            enteredPassword = value!;
                          },
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: _submit,
                          child: Text(_isLogin? 'Login': 'Signup'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          style: TextButton.styleFrom(
                            primary: kPrimaryColor,
                          ),
                          child: Text(_isLogin?'Create new account': "I already have an account"),
                        ),
                        if(_isLogin)
                          Card(
                            child: FloatingActionButton.extended(
                              onPressed: () async {
                                  await FirebaseServices().signInWithGoogle();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TabsScreen()),
                                );
                              },
                              icon: Image.asset(
                                'assets/images/google.png', // Replace with your Google icon image
                                height: 30, // Adjust height as needed
                                width: 30, // Adjust width as needed
                              ),
                              label: Text("Sign In With Google"),
                              foregroundColor: Colors.orangeAccent,
                              backgroundColor: Colors.white,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
