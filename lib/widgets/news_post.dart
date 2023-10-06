/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universe/widgets/post_display.dart';

class NewsPost extends StatelessWidget {
  const NewsPost({super.key});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (ctx,postsSnapshots) {
              final loadedMessages = postsSnapshots.data!.docs;
              return SingleChildScrollView(
                child: ListView.builder(
                    itemCount: loadedMessages.length,
                    itemBuilder: (context, index){
                      return ListTile(
                        title: Text(loadedMessages[index].data()['text']),
                      );
                    }
                ),
              );
            });



    */
/*StreamBuilder(stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (ctx,postsSnapshots){
          if(postsSnapshots.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(postsSnapshots.hasError){
            return Center(
              child: Text(
                'Something went wrong..',
                style: Theme.of(context).textTheme.headline4,
              ),
            );
          }
          if(!postsSnapshots.hasData || postsSnapshots.data!.docs.isEmpty){
            return Center(
              child: Text(
                'No post found.',
                style: Theme.of(context).textTheme.headline4,
              ),
            );
          }
          final loadedMessages = postsSnapshots.data!.docs;
          print(loadedMessages.length);
          return ListView.builder(itemCount:loadedMessages.length,itemBuilder: (ctx, index)=>
              Text(loadedMessages[index].data()['text'])

          );
        },) ;*//*


    */
/**//*

  }
}
*/
