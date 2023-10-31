import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalNewMessage extends StatefulWidget {
  const PersonalNewMessage({
    super.key,
    required this.visitedUserEmail,
    required this.onClose,
  });

  final VoidCallback onClose;
  final String? visitedUserEmail;

  @override
  _PersonalNewMessageState createState() => _PersonalNewMessageState();
}

class _PersonalNewMessageState extends State<PersonalNewMessage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? _currentUser;
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _messageController = TextEditingController();
  }

  Future<void> _sendMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }

    _messageController.clear();

    if (_currentUser == null) {
      // Handle the case when the user is not logged in
      return;
    }

    final userData =
    await _firestore.collection('users').doc(_currentUser!.uid).get();

    if (!userData.exists) {
      // Handle the case when user data is not available
      return;
    }

    String directMessageId = _firestore.collection('directMessages').doc().id;

    await _firestore.collection('directMessages').add({
      'text': enteredMessage,
      'directMessageId': directMessageId,
      'createdAt': Timestamp.now(),
      'senderUserId': _currentUser!.uid,
      'senderUserEmail': _currentUser!.email,
      'receiverUserEmail': widget.visitedUserEmail,
      'senderUsername': userData['username'],
      'senderUserImage': userData['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 40),
          // AppBar with close button and title
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
            ],
          ),
          // Message input field and send button
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 14, right: 1),
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
