import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget{
  final myUid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Chats").where("users", arrayContains: myUid, ).snapshots(),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemBuilder: (_, i) => ListTile(
                    leading: CircleAvatar(),
                    title: Text(snapshot.data.docs[i].data()['users'][0]),
                  ),
                  itemCount: snapshot.data.docs.length ?? 0,
                ),
    );
  }
}
