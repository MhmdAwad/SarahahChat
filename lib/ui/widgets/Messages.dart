import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'MessageBubble.dart';

class Messages extends StatelessWidget {
  final fireStore;

  Messages(this.fireStore);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: fireStore.orderBy("time", descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Expanded(
            child: ListView.builder(
              reverse: true,
              itemBuilder: (_, i) =>
                  MessageBubble(
                      snapshot.data.docs[i].data()['text'],
                      snapshot.data.docs[i].data()['sender'] ==
                          FirebaseAuth.instance.currentUser.uid),
              itemCount: snapshot.data.docs.length ?? 0,
            ),
          );
        });
  }
  }

