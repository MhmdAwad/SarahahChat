import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  static const ROUTE_NAME = "ConversationScreen";

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String conversationID;

  @override
  void didChangeDependencies() {
    conversationID = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Conversation")),
      body: conversationID == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text(conversationID),
    );
  }
}
