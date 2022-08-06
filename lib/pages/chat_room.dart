import 'package:firebase_day36/providers/chat_room_provider..dart';
import 'package:firebase_day36/widgets/message_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  static const String routeName = '/chat_room';
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final msgController = TextEditingController();

  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<ChatRoomProvider>(context).getAllChatRoomMessages();
    }
    isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    msgController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChatRoomProvider>(
        builder: (context, provider, _) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                  reverse: true,
                  itemCount: provider.msgList.length,
                  itemBuilder: (context, index) {
                    final msg = provider.msgList[index];
                    return MessageItem(messageModel: msg);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: msgController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16))))),
                  IconButton(
                    onPressed: () {
                      provider.addMsg(msgController.text);
                      msgController.clear();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
