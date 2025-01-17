import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sarahah_chat/utils/Constants.dart';
import 'package:share/share.dart';

class AccountScreen extends StatefulWidget {
  static const ROUTE_NAME = "AccountScreen";

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var isLoading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String username;
  String userMail;
  String userImage;
  String userLink;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      userLink = value.data()[USERS_LINK];
      username = value.data()[USERNAME];
      userImage = value.data()[USER_IMAGE];
      userMail = value.data()[EMAIL];
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  void _showSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Copied."),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Account"),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: userImage.startsWith("http")
                          ? NetworkImage(userImage)
                          : AssetImage(
                              "assets/images/incoginto.png",
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      username,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(userMail,
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            userLink,
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onLongPress: () {
                            Clipboard.setData(ClipboardData(text: userLink));
                            _showSnackBar();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () => Share.share(userLink,
                              subject: 'Look this is my Sarahah Chat Link'),
                        )
                      ],
                    ),
                  ],
                ),
              ));
  }
}
