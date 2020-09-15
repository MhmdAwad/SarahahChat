import 'package:flutter/material.dart';
import 'package:sarahah_chat/ui/screens/ConversationScreen.dart';
import 'package:sarahah_chat/utils/Constants.dart';

class ChatItemWidget extends StatelessWidget {
  final String chatID;
  final String chatName;
  final String lastMsg;

  ChatItemWidget(this.chatID, this.chatName, this.lastMsg);

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      onTap: () => Navigator.of(context).pushNamed(
          ConversationScreen.ROUTE_NAME,
          arguments: {
            ID:chatID,
            NAME:chatName
          }),
      leading: CircleAvatar(child: Image.asset("assets/images/incoginto.png",),),
      title: Text(chatName),
      subtitle: Text(lastMsg),
    );
  }
}
