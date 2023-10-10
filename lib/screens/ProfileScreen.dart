import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universe/models/City.dart';
import 'package:universe/models/State.dart';
import 'package:universe/screens/AuthScreen.dart';
import 'package:universe/services/firebase_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  String? _userEmail;
  String? _username;
  String? _userPhotoUrl;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    print("photo URL $_userPhotoUrl");
  }

  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _username = user.displayName;
        _userEmail = user.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  // Hide if photo URL is null

                  SizedBox(height: 20),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: _userEmail)
                          .snapshots(),
                      builder: (context, snapshot) {
                        final docs = snapshot.data?.docs;
                        print("Length-> ${docs?.length}");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Something went wrong..',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              'No post found.',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          );
                        }
                        final username = docs?[0].data()['username'];
                        final userPhotoUrl = docs?[0].data()['image_url'];
                        return Column(
                          children: [
                            _userPhotoUrl != null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        NetworkImage(_userPhotoUrl!),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(userPhotoUrl),
                                  ),
                            SizedBox(height: 10),
                            username != null
                                ? Text(
                                    username,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    _username!,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        );
                      }),

                  // Hide if username is null

                  SizedBox(height: 10),

                  _userEmail != null
                      ? Text(
                          '$_userEmail',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        )
                      : SizedBox(), // Hide if email is null

                  SizedBox(height: 30),

                  Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: _userEmail)
                            .snapshots(),
                        builder: (context, snapshot) {
                          final docs = snapshot.data?.docs;
                          print("Length-> ${docs?.length}");
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Something went wrong..',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                'No post found.',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            );
                          }
                          final phoneNumber = docs?[0].data()['phone'];
                          final division = docs?[0].data()['division'];
                          final district = docs?[0].data()['district'];
                          print(phoneNumber);
                          return Center(
                            child: Column(
                              children: [
                                phoneNumber.isNotEmpty
                                    ? Text(
                                        "Phone : $phoneNumber",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(height: 30),
                                division != null || division != 'Select Division'
                                    ? Text(
                                        "Division : $division",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Roboto',
                                          color: Colors.blueGrey,
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(height: 30),
                                district != null || district != 'Select District'
                                    ? Text(
                                        "District : $district",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.teal,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          );
                        }),
                  ),

                  SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseServices().signout();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // Background color
                      onPrimary: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Rounded corners
                      ),
                      elevation: 3, // Elevation to create a shadow effect
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            30.0), // Rounded corners for ink splash
                      ),
                      child: Container(
                        constraints: const BoxConstraints(
                            minWidth: 150.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () => _onBackPressed(context));
  }

  _onBackPressed(BuildContext context) async {
    bool? exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Do you want to exit the app?"),
            actions: [
              TextButton(
                  child: Text("No"),
                  onPressed: () => Navigator.of(context).pop(false)),
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  // Exit the app
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        });
    return exitApp ?? false;
  }
}
