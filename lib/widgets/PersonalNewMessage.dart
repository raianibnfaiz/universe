import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalNewMessage extends StatefulWidget {
  const PersonalNewMessage(
      {super.key, required this.visitedUserEmail, required this.onClose});
  final VoidCallback onClose;
  final String? visitedUserEmail;

  @override
  State<PersonalNewMessage> createState() => _PersonalNewMessageState();
}

class _PersonalNewMessageState extends State<PersonalNewMessage> {
  void _sendMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    String directMessageId =
        FirebaseFirestore.instance.collection('directMessages').doc().id;

    FirebaseFirestore.instance.collection('directMessages').add({
      'text': enteredMessage,
      'directMessageId': directMessageId,
      'createdAt': Timestamp.now(),
      'senderuserId': user?.uid,
      'senderuserEmail': user?.email,
      'receiveruserEmail': widget.visitedUserEmail,
      'senderUsername': userData?.data()!['username'],
      'senderUserImage': userData?.data()!['image_url'],
    });
  }

  var _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 40),
          // Adjust the width as needed
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: widget.onClose,
                icon: Icon(Icons.close),
              ),
              Text(
                'Direct Message',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 40),
              // Adjust the width as needed
            ],
          ),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 14,right: 1),
              child: TextField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(labelText: "Send a message..."),
              ),
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
        ],
      ),
    );
  }
}

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
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    if (userSnapshot.exists) {
      await FirebaseFirestore.instance.collection('users').doc(postId).update({
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
