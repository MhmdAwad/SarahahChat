import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sarahah_chat/utils/Constants.dart';

import 'MessageBubble.dart';

class Messages extends StatelessWidget {
  final fireStore;
  Messages(this.fireStore);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: fireStore.collection(MESSAGES).orderBy(TIME, descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          final docs = snapshot.data.docs;
          return  ListView.builder(
              reverse: true,
              itemBuilder: (_, i) =>
                  MessageBubble(
                      docs[i].data()[TEXT],
                      docs[i].data()[TIME],
                      docs[i].data()[SENDER] ==
                          FirebaseAuth.instance.currentUser.uid),
              itemCount: snapshot.data.docs.length ?? 0,
          );
        });
  }
  }

