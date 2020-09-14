import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  String foundUserUid ="";

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
            if (findStatus != FindStatus.SUCCESS)
              Row(
                children: [
                  Expanded(
                    child: TextFormWidget("Add user link", controller,
                        TextInputAction.done, false, (val) {}),
                  ),
                  FlatButton(
                    child: Text("check"),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _findFriend,
                  )
                ],
              ),
            if (findStatus == FindStatus.SUCCESS)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    radius: 60,
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Text("Chat",style: TextStyle(color: Colors.white),),
                      color: Theme.of(context).accentColor,
                      onPressed: (){
                        FirebaseFirestore.instance.collection("Chats").add({
                          "users":[FirebaseAuth.instance.currentUser.uid, foundUserUid],

                        }).then((value) => print("SS ${value.id}  == ${value.path}"));
                      },
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
