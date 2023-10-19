import 'package:flutter/cupertino.dart';
import 'package:universe/widgets/NewMessage.dart';

import '../widgets/chat_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: ChatMessage()),
        NewMessage(),
      ],
    );
  }
}
