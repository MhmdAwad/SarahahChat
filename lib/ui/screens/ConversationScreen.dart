import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sarahah_chat/ui/widgets/MessageBubble.dart';

class ConversationScreen extends StatefulWidget {
  static const ROUTE_NAME = "ConversationScreen";

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String conversationID;
  var fireStore;

  final controller = TextEditingController();

  @override
  void didChangeDependencies() {
    conversationID = ModalRoute
        .of(context)
        .settings
        .arguments;
    fireStore = FirebaseFirestore.instance
        .collection("Chats")
        .doc(conversationID)
        .collection("messages");
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
          : StreamBuilder(
          stream: fireStore.orderBy("time", descending: true).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemBuilder: (_, i) =>
                        MessageBubble(snapshot.data.docs[i].data()['text'],
                            snapshot.data.docs[i].data()['sender'] == FirebaseAuth.instance.currentUser.uid),
                    itemCount: snapshot.data.docs.length ?? 0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                              labelText: "Start messaging..."),
                        ),
                      ),
                      FlatButton(
                        child: Text("Send"),
                        onPressed: () async {
                          if (controller.text.isNotEmpty) {
                            fireStore.add({
                              'text': controller.text,
                              "time": Timestamp.now(),
                              "sender": FirebaseAuth.instance.currentUser.uid
                            });
                            controller.clear();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
