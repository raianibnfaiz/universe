import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<dynamic> uC = [];

class LoadComments extends StatefulWidget {
  const LoadComments({required this.loadedPostId, super.key});
  final String? loadedPostId;
  @override
  State<LoadComments> createState() => _LoadCommentsState();
}

class _LoadCommentsState extends State<LoadComments> {




  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('postId', isEqualTo: widget.loadedPostId)
          .snapshots(),
      builder: (context, snapshot) {
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

        // Extract the comments from the data
        List<dynamic> comments = snapshot.data?.docs[0]['comment'] ?? [];
        int commentLength = comments.length;

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: commentLength,
          itemBuilder: (context, index) {
            // Assuming comments is a list of Map<String, dynamic>
            String comment = comments[index]['comment'];
            String username = comments[index]['username'];
            String userImageURL = comments[index]['imageUrl']; // Assuming this is the URL of the user's image

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userImageURL),
                radius: 20.0, // Adjust the size as needed
              ),
              subtitle: Text(comment),
              title: Text(
                username,
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),

            );

          },

        );

      },
    );
  }

    /*Expanded(
      child: FutureBuilder<List<dynamic>>(
        future: _commentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Container(
              child: Center(child: Text("Error: ${snapshot.error}")),
            );
          } else {
            List<Map<String, dynamic>>? comments =
                snapshot.data?.cast<Map<String, dynamic>>();
            print(comments);
            return ListView.builder(
                itemCount: comments?.length,
                itemBuilder: (context, index) {
                  Text("Comment:");
                });
            itemBuilder:
            {}
            *//*ListView.builder(
          itemCount: comments?.length ?? 0,
          itemBuilder: (context, index) {
            Map<String, dynamic>? commentData = comments?[index];
            String commentText = commentData?['comment'] ?? '';
            String commenterUsername = commentData?['username'] ?? '';
            Timestamp timestamp = commentData?['timestamp'] ?? Timestamp(0, 0);

            // Convert timestamp to DateTime
            DateTime dateTime = timestamp.toDate();

            return ListTile(
              title: Text(commentText),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Comment by: $commenterUsername'),
                  Text('Timestamp: $dateTime'),
                ],
              ),
            );
          },
        );*//*
            *//*ListView.builder(
          itemCount: comments?.length ?? 0,
          itemBuilder: (context, index) {
            Map<String, dynamic>? commentData = comments?[index];
            print("commentData: $commentData");
            String commentText = commentData?['comment'] ?? '';
            String commenterUsername = commentData?['username'] ?? '';

            return ListTile(
              title: Text(commentText),
              subtitle: Text('Comment by: $commenterUsername'),
            );
          },
        );*//*
          }
        },
      ),
    );*/

}
