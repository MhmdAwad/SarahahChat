import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sarahah_chat/ui/widgets/Messages.dart';
import 'package:sarahah_chat/ui/widgets/NewMessage.dart';
import 'package:sarahah_chat/utils/Constants.dart';

class ConversationScreen extends StatefulWidget {
  static const ROUTE_NAME = "ConversationScreen";

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String conversationID;
  String conversationName;
  var fireStore;

  @override
  void didChangeDependencies() {
    _getConversationData();
    super.didChangeDependencies();
  }

  void _getConversationData() {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    conversationID = args[ID];
    conversationName = args[NAME];
    fireStore = FirebaseFirestore.instance
        .collection(CHATS)
        .doc(conversationID)
        .collection(MESSAGES);
  }

  void addNewMessage(text, time, sender) {
    fireStore.add({TEXT: text, TIME: time, SENDER: sender});
    FirebaseFirestore.instance
        .collection(CHATS)
        .doc(conversationID)
        .update({LAST_MSG: text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(conversationName)),
      body: Column(
        children: [
          Expanded(child: Messages(fireStore)),
          NewMessage(addNewMessage),
        ],
      ),
    );
  }
}
