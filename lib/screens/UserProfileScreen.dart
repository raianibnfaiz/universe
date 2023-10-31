import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/PersonalNewMessage.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen(
      {super.key,
      required this.username,
      required this.imageUrl,
      required this.userEmail});
  final String? username;
  final String? imageUrl;
  final String? userEmail;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<void> submitComment(String postId, String comment) async {
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    final docs = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email);
    QuerySnapshot userQuerySnapshot = await docs.get();
    if (userQuerySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> userData =
      userQuerySnapshot.docs[0].data() as Map<String, dynamic>;

      // Accessing properties of the user document
      String? username = userData['username'];
      String? email = userData['email'];
      // Add more properties as needed

      // Print or use the user data
      print('Username: $username');
      print('Email: $email');
      // Print or use other properties as needed
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get();

      if (userSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(postId)
            .update({
          'chats': FieldValue.arrayUnion([
            {
              'imageUrl': userData['image_url'],
              'userId': user!.uid,
              'comment': comment,
              'username': userData['username'],
              'userEmail': email,
              'timestamp': Timestamp.now(),
            }
          ]),
        });
      }
      // Accessing the first document's data (assuming there's only one document)
    } else {
      print('No user found with the specified email.');
    }

    // Assuming 'comments' is a subcollection under 'posts'
  }
  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: Container(
            child: PersonalNewMessage(
              onClose: () {
                Navigator.of(context).pop();
              },
              visitedUserEmail: widget.userEmail,
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    // Build the UI for the profile page
    // You can display user information, posts, etc., on this page
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.blueGrey,
      ),
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
                      .where('email', isEqualTo: widget.userEmail)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final docs = snapshot.data?.docs;
                    print("Length-> ${docs?.length}");
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                        widget.imageUrl != null
                            ? Hero(
                                tag:
                                    'avatar-${widget.username}', // Same unique tag for Hero animation
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage:
                                      NetworkImage(widget.imageUrl ?? ''),
                                ),
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
                                "No username",
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

              widget.userEmail != null
                  ? Text(
                      '${widget.userEmail}',
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
                        .where('email', isEqualTo: widget.userEmail)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final docs = snapshot.data?.docs;
                      print("Length-> ${docs?.length}");
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                            division != null
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
                            district != null
                                ? Text(
                                    "District : $district",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.teal,
                                    ),
                                  )
                                : SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                onPressed:_openAddExpensesOverlay,
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
                                      'Send Message',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
