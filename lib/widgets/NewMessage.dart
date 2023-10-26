import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _messageController = TextEditingController();
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final enteredMessage = _messageController.text;
    if (enteredMessage
        .trim()
        .isEmpty) {
      return;
    }
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user?.uid,
      'username': user?.displayName,
      'userImage': user?.photoURL,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
