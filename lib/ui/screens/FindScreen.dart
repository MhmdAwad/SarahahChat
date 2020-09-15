import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sarahah_chat/ui/screens/ConversationScreen.dart';
import 'package:sarahah_chat/ui/widgets/FindUserWidger.dart';
import 'package:sarahah_chat/ui/widgets/FoundUserWidget.dart';
import 'package:sarahah_chat/utils/Constants.dart';
import 'package:sarahah_chat/utils/FindStatus.dart';

class FindScreen extends StatefulWidget {
  @override
  _FindScreenState createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  FindStatus findStatus = FindStatus.FAILED;
  String foundUsername = "";
  String foundUserImage = "";
  String foundUserUid = "";

  void _changeLoading(status) {
    setState(() {
      findStatus = status;
    });
  }

  void _showErrorDialog(String errorMsg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(errorMsg),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _changeLoading(FindStatus.FAILED);
            },
          )
        ],
      ),
    );
  }

  void _findFriend(userLink) {
    _changeLoading(FindStatus.LOADING);
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance
        .collection(USERS)
        .where(USERS_LINK, isEqualTo: userLink)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        _changeLoading(FindStatus.FAILED);
        _showErrorDialog("user link in invalid.");
      } else {
        foundUsername = value.docs[0].data()[USERNAME];
        foundUserUid = value.docs[0].data()[UID];
        foundUserImage = value.docs[0].data()[USER_IMAGE];
        _changeLoading(FindStatus.SUCCESS);
      }
    });
  }

  void createChat() async {
    if (foundUserUid == FirebaseAuth.instance.currentUser.uid) {
      _showErrorDialog("You can't chat to yourself!");
      return;
    }
    final myUid = FirebaseAuth.instance.currentUser.uid;
    String existChat = await checkChatExist();
    if (existChat != null) {
      Navigator.of(context)
          .pushNamed(ConversationScreen.ROUTE_NAME, arguments: existChat);
      return;
    }
    FirebaseFirestore.instance.collection(CHATS).add({
      USERS: [myUid, foundUserUid],
      RECEIVED_USERNAME: foundUsername,
      RECEIVED_USER_UID: foundUserUid,
    }).then((value) => Navigator.of(context).pushNamed(
        ConversationScreen.ROUTE_NAME,
        arguments: {ID: value.id, NAME: foundUsername}));
  }

  Future<String> checkChatExist() async {
    String existChat;
    final data = await FirebaseFirestore.instance
        .collection(CHATS)
        .where(
          USERS,
          arrayContains: FirebaseAuth.instance.currentUser.uid,
        )
        .get();

    for (var element in data.docs) {
      if (element.data()[USERS][0] == foundUserUid ||
          element.data()[USERS][1] == foundUserUid) {
        existChat = element.id;
        break;
      }
    }
    return existChat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              FindUserWidget(findStatus, _findFriend),
              SizedBox(
                height: 15,
              ),
              if (findStatus == FindStatus.SUCCESS)
                FoundUserWidget(
                  foundUserImage,
                  foundUsername,
                  createChat,
                  _changeLoading,
                )
            ],
          ),
        ),
      ),
    );
  }
}
