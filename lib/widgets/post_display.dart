import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universe/screens/UserProfileScreen.dart';
import 'package:universe/widgets/load_comment.dart';

class PostDisplay extends StatelessWidget {
  const PostDisplay({
    super.key,
    required this.loadedMessage,
    required this.loadedImage,
    required this.loadedUsername,
    required this.loadedPostId,
    required this.loadedEmail,
    required this.commentController,
  });
  final String? loadedMessage;
  final String? loadedImage;
  final String? loadedUsername;
  final String? loadedPostId;
  final String? loadedEmail;
  final TextEditingController commentController;

  /* Future<void> submitComment(String postId, String comment) async {
    // Assuming 'comments' is a subcollection under 'posts'
    await FirebaseFirestore.instance.collection('comments').doc(postId).set({
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
      // Add other relevant data associated with the comment if needed
    });
  }*/
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
          .collection('posts')
          .doc(postId)
          .get();

      if (userSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'comment': FieldValue.arrayUnion([
            {
              'imageUrl': userData['image_url'],
              'userId': user!.uid,
              'comment': comment,
              'username': userData['username'],
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.blueGrey, width: 0.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.white54.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post content and writer's writings
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Post content
                    if (loadedImage != null)
                      InkWell(
                        onTap: () {
                          // Navigate to the profile page and pass user information
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfileScreen(
                                username: loadedUsername,
                                imageUrl: loadedImage,
                                userEmail: loadedEmail,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag:
                              'avatar-${loadedUsername}', // Unique tag for the Hero animation
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage(
                              loadedImage!,
                            ),
                          ),
                        ),
                      ),

                    // Writer's writings
                    InkWell(
                      onTap: () {
                        // Navigate to the profile page and pass user information
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfileScreen(
                              username: loadedUsername,
                              imageUrl: loadedImage,
                              userEmail: loadedEmail,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        loadedUsername!,
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.0),

                // Profile image
                Center(
                  child: Text(
                    loadedMessage!,
                    style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat'),
                  ),
                ),

                SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        String comment = commentController.text;
                        if (comment.isNotEmpty) {
                          // Assuming you have access to the postId
                          String? postId =
                              loadedPostId; // Replace with the actual postId
                          submitComment(postId!, comment);
                          commentController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey.withOpacity(0.9),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Comment',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontFamily: 'Montserrat'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.0),

                LoadComments(loadedPostId: loadedPostId)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
