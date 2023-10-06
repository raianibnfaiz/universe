import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return  Column(
      children:[
        const NewPost(),
        Expanded(
            child: ListView.builder(
              itemCount: textItems.length,
              itemBuilder: (context, index) {
                return PostDisplay(loadedMessage: textItems[index]);
              },
            ),
        )
      ],
    );
  }
}
