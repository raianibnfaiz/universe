import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextEditingController commentController = TextEditingController();

class PostDisplay extends StatelessWidget {
  const PostDisplay(
      {super.key,
      required this.loadedMessage,
      required this.loadedImage,
      required this.loadedUsername,
        required this.loadedPostId});
  final String? loadedMessage;
  final String? loadedImage;
  final String? loadedUsername;
  final String? loadedPostId;
  Future<void> submitComment(String postId, String comment) async {
    // Assuming 'comments' is a subcollection under 'posts'
    await FirebaseFirestore.instance
        .collection('comments')
        .doc(postId)
        .set({
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
      // Add other relevant data associated with the comment if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 3.0),
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
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                          loadedImage!,
                        ),
                      ),

                    // Writer's writings
                    Text(
                      loadedUsername!,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 8.0),

                // Profile image
                Center(
                  child: Text(
                    loadedMessage!,
                    style: TextStyle(fontSize: 16.0,fontFamily: 'Montserrat'),
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
                  String? postId = loadedPostId; // Replace with the actual postId
                  submitComment(postId!, comment);
                  commentController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrangeAccent,
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
                    style: TextStyle(fontSize: 15.0, color: Colors.white,fontFamily: 'Montserrat'),
                  ),
                ],
              ),
            ),
          ],
        ),



        // Comment text field

              ],
            ),
          ],
        ),
      ),
    );
  }
}
