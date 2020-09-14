import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sarahah_chat/ui/screens/ConversationScreen.dart';
import 'package:sarahah_chat/ui/widgets/TextFormWidget.dart';

enum FindStatus { FAILED, SUCCESS }

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

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text("user link in invalid."),
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
    FirebaseFirestore.instance
        .collection("Users")
        .where("userLink", isEqualTo: controller.text)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        _changeLoading(FindStatus.FAILED);
        _showErrorDialog();
      } else {
        foundUsername = value.docs[0].data()['username'];
        foundUserUid = value.docs[0].data()['uid'];
        foundUserImage = value.docs[0].data()['userImage'];
        _changeLoading(FindStatus.SUCCESS);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
              Row(
                children: [
                  Expanded(
                    child: TextFormWidget("Add user link", controller,
                        TextInputAction.done, false, (val) {}),
                  ),
                  FlatButton(
                    child: Text("find"),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _findFriend,
                  )
                ],
              ),
            SizedBox(height: 15,),
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
                        onPressed: () {
                          FirebaseFirestore.instance.collection("Chats").add({
                            "users": [
                              FirebaseAuth.instance.currentUser.uid,
                              foundUserUid
                            ],
                            "receivedUsername":foundUsername,
                            "receivedUserUid": foundUserUid,
                          }).then((value) => Navigator.of(context).pushNamed(ConversationScreen.ROUTE_NAME,
                          arguments: value.id));
                        },
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
