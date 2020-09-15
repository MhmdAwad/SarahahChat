import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sarahah_chat/ui/screens/ConversationScreen.dart';
import 'package:sarahah_chat/ui/widgets/TextFormWidget.dart';

enum FindStatus { FAILED, SUCCESS, LOADING }

class FindScreen extends StatefulWidget {
  @override
  _FindScreenState createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  final controller = TextEditingController();
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

  void _findFriend() {
    _changeLoading(FindStatus.LOADING);
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance
        .collection("Users")
        .where("userLink", isEqualTo: controller.text)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        _changeLoading(FindStatus.FAILED);
        _showErrorDialog("user link in invalid.");
      } else {
        foundUsername = value.docs[0].data()['username'];
        foundUserUid = value.docs[0].data()['uid'];
        foundUserImage = value.docs[0].data()['userImage'];
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
    FirebaseFirestore.instance.collection("Chats").add({
      "users": [myUid, foundUserUid],
      "receivedUsername": foundUsername,
      "receivedUserUid": foundUserUid,
    }).then((value) => Navigator.of(context).pushNamed(
        ConversationScreen.ROUTE_NAME,
        arguments: {'id': value.id, 'name': foundUsername}));
  }

  Future<String> checkChatExist() async {
    String existChat;
    final data = await FirebaseFirestore.instance
        .collection("Chats")
        .where(
          "users",
          arrayContains: FirebaseAuth.instance.currentUser.uid,
        )
        .get();

    for (var element in data.docs) {
      if (element.data()['users'][0] == foundUserUid ||
          element.data()['users'][1] == foundUserUid) {
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
              Row(
                children: [
                  Expanded(
                    child: TextFormWidget("Add user link", controller,
                        TextInputAction.search, false, null),
                  ),
                  findStatus == FindStatus.LOADING
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          icon: Icon(Icons.search,
                              color: Theme.of(context).primaryColor),
                          onPressed: _findFriend,
                        )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              if (findStatus == FindStatus.SUCCESS)
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(foundUserImage),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        foundUsername,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      FlatButton(
                        child: Text("cancel"),
                        textColor: Colors.red,
                        onPressed: () => _changeLoading(FindStatus.FAILED),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "CHAT NOW",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: createChat,
                        ),
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
