import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sarahah_chat/ui/screens/ConversationScreen.dart';

class ChatScreen extends StatelessWidget {
  final myUid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Chats")
          .where(
            "users",
            arrayContains: myUid,
          )
          .snapshots(),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) => snapshot
                  .connectionState ==
              ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () => Navigator.of(context).pushNamed(
                      ConversationScreen.ROUTE_NAME,
                      arguments: snapshot.data.docs[i].id),
                  leading: CircleAvatar(),
                  title: Text(snapshot.data.docs[i].data()['receivedUsername']),
                ),
              ),
              itemCount: snapshot.data.docs.length ?? 0,
            ),
    );
  }
}
