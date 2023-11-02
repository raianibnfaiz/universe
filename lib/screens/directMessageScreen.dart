import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DirectMessagesScreen extends StatelessWidget {
  final String userId; // The user's ID to fetch direct messages
  final String? visitedUserEmail; // The email of the visited profile

  DirectMessagesScreen({required this.userId, required this.visitedUserEmail});

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(top: 24,right: 16,left: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
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
            Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    final userData = snapshot.data;
                    if (!userData!.exists) {
                      return Text('User data not found');
                    }

                    final messages = userData['directMessages'] as List<dynamic>;

                    if (messages.isEmpty) {
                      return Text('No direct messages available.');
                    }

                    final filteredMessages = messages.where((message) {
                      final senderEmail = message['senderUserEmail'];
                      final receiverEmail = message['receiverUserEmail'];
                      // Check if the message is from or to the visited user
                      return senderEmail == visitedUserEmail || receiverEmail == visitedUserEmail;
                    }).toList();

                    if (filteredMessages.isEmpty) {
                      return Text('No direct messages with the visited user.');
                    }

                    return ListView.builder(
                      itemCount: filteredMessages.length,
                      itemBuilder: (context, index) {
                        final message = filteredMessages[index];

                        return ListTile(
                          title: Text(message['text']),
                          subtitle: Text('Sender: ${message['senderUsername']}'),
                          // You can add more details from the message as needed
                        );
                      },
                    );
                  },
                ),



            ),
            SizedBox(height: 40),


          ],
        ),
      );
  }
}
