import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sarahah_chat/ui/widgets/Messages.dart';
import 'package:sarahah_chat/ui/widgets/NewMessage.dart';

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
  void initState() {
    fireStore = FirebaseFirestore.instance
        .collection("Chats")
        .doc(conversationID)
        .collection("messages");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    conversationID = args['id'];
    conversationName = args['name'];
    super.didChangeDependencies();
  }

  void addNewMessage(text, time, sender) {
    fireStore.add({'text': text, "time": time, "sender": sender});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(conversationName)),
      body: Column(
        children: [
          Messages(fireStore),
          NewMessage(addNewMessage),
        ],
      ),
    );
  }
}
