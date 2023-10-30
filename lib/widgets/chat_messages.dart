import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MessageBubble.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt',descending: true).snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data found'),);
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'),);
        }
        final loadedMessage = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            right: 13,
            left: 13,
          ),
          reverse: true,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessage[index].data();
            final nextChatMessage = index+1 < loadedMessage.length?
                loadedMessage[index+1].data()
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId = nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if(nextUserIsSame){
              return MessageBubble.next(message: chatMessage['text'], isMe: authenticatedUser.uid == currentMessageUserId);
            }
            else{
              return MessageBubble.first(userImage: chatMessage['userImage'], username: chatMessage['username'], message: chatMessage['text'], isMe: authenticatedUser.uid == currentMessageUserId);
            }
          }
          ,
          itemCount: loadedMessage.length,);
      },);
  }
}
