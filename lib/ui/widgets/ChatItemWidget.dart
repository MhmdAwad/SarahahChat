import 'package:flutter/material.dart';
import 'package:sarahah_chat/ui/screens/ConversationScreen.dart';
import 'package:sarahah_chat/utils/Constants.dart';

class ChatItemWidget extends StatelessWidget {
  final String chatID;
  final String chatName;
  final String lastMsg;
  final int unseenMessages;

  ChatItemWidget(this.chatID, this.chatName, this.lastMsg, this.unseenMessages);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(
          ConversationScreen.ROUTE_NAME,
          arguments: {ID: chatID, NAME: chatName}),
      leading: CircleAvatar(
        child: Image.asset(
          "assets/images/incoginto.png",
        ),
        radius: 30,
      ),
      title: Text(
        chatName,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(lastMsg),
      trailing: unseenMessages == 0
          ? Container(
              width: 0,
              height: 0,
            )
          : CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(unseenMessages.toString()),
              radius: 15,
            ),
    );
  }
}
