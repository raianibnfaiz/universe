import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universe/widgets/news_post.dart';
import 'package:universe/widgets/post_display.dart';

import '../widgets/new_post.dart';

class BreakingFeed extends StatelessWidget {
  const BreakingFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> textItems = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
      'Item 5',
      'Item 5',
      'Item 5',
      'Item 5',
      'Item 5',
      'Item 5',
      'Item 5',
      'Item 5',
      'Item 5',
    ];
    return  WillPopScope(
        child: Column(
          children:[
            const NewPost(),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final loadedMessages = snapshot.data?.docs;
                    print("Length-> ${loadedMessages?.length}");
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    if(snapshot.hasError){
                      return Center(
                        child: Text(
                          'Something went wrong..',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      );
                    }
                    if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                      return Center(
                        child: Text(
                          'No post found.',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: loadedMessages?.length,
                      itemBuilder: (context, index) {
                        return PostDisplay(loadedMessage: loadedMessages?[index].data()['text'], loadedImage: loadedMessages?[index].data()['userImage'],loadedUsername: loadedMessages?[index].data()['username'],);
                      },
                    );
                  }
              ),
            )
          ],
        ),
        onWillPop: ()=>_onBackPressed(context));
  }
  _onBackPressed(BuildContext context) async{
    bool? exitApp = await showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Do you want to exit the app?"),
            actions: [
              TextButton(
                  child: Text("No"),
                  onPressed: ()=>Navigator.of(context).pop(false)),
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  // Exit the app
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        });
    return exitApp ?? false;
  }
}
