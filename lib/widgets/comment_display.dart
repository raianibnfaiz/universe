import 'package:flutter/cupertino.dart';

class CommentDisplay extends StatefulWidget {
  const CommentDisplay({super.key});

  @override
  State<CommentDisplay> createState() => _CommentDisplayState();
}

class _CommentDisplayState extends State<CommentDisplay> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> userComment = ['comment1', 'comment2', 'comment3'];
    return const Placeholder();
  }
}
