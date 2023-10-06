import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostDisplay extends StatelessWidget {


  const PostDisplay({super.key, required this.loadedMessage});
  final String? loadedMessage;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post content and writer's writings
           /* CircleAvatar(
              radius: 20.0,
              backgroundImage: AssetImage('assets/images/scoop_insight.jpg'),
            ),*/

            SizedBox(height: 8.0),

            // Profile image
            Text(
              loadedMessage!,
              style: TextStyle(fontSize: 16.0),
            ),

            SizedBox(height: 8.0),

            // Comment text field
            TextField(
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
