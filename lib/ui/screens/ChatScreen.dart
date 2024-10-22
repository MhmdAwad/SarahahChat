import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sarahah_chat/ui/widgets/ChatItemWidget.dart';
import 'package:sarahah_chat/utils/Constants.dart';

class ChatScreen extends StatelessWidget {
  static const ROUTE_NAME = "ChatScreen";
  final myUid = FirebaseAuth.instance.currentUser.uid;

  String _conversationName(receivedName, receivedUid) {
    return receivedUid == myUid ? HIDDEN_USERS : receivedName;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(CHATS)
            .where(
              USERS,
              arrayContains: myUid,
            ).snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final docs = snapshot.data.docs;
          if(docs.isEmpty)
            return Center(child: Text("No chats yet! Add one now."),);
          return ListView.builder(
            itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChatItemWidget(
                    docs[i].id,
                    _conversationName(docs[i].data()[RECEIVED_USERNAME],
                        docs[i].data()[RECEIVED_USER_UID]),
                docs[i].data()[LAST_MSG],
                docs[i].data()[LAST_SENDER] == myUid?0: docs[i].data()[UNSEEN_MESSAGES])),
            itemCount: snapshot.data.docs.length ?? 0,
          );
        });
  }
}
