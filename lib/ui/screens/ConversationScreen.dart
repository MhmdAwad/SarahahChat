import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  DocumentReference fireStore;
  int unseenMessages;
  var unseenListener;


  @override
  void didChangeDependencies() {
    _getConversationData();
    super.didChangeDependencies();
  }

  void _getConversationData() {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    conversationID = args[ID];
    conversationName = args[NAME];
    fireStore =
        FirebaseFirestore.instance.collection(CHATS).doc(conversationID);
    unseenListener = fireStore.snapshots().listen((event) {
      if(FirebaseAuth.instance.currentUser.uid != event.data()[LAST_SENDER]){
        fireStore.update({
          UNSEEN_MESSAGES:0
        });
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    unseenListener.cancel();
  }

  void addNewMessage(text, time, sender) {
    fireStore
        .collection(MESSAGES)
        .add({TEXT: text, TIME: time, SENDER: sender});
    fireStore.get().then((value) {
      fireStore.update({
        LAST_MSG: text,
        UNSEEN_MESSAGES: ++value.data()[UNSEEN_MESSAGES],
        LAST_SENDER: sender
      });
    });
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
