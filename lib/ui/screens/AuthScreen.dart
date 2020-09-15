import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sarahah_chat/models/UserInformation.dart';
import 'package:sarahah_chat/ui/widgets/AuthFormWidget.dart';
import 'package:sarahah_chat/utils/Constants.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.green, Color.fromRGBO(215, 251, 232, .9)]),
          ),
        ),
        AuthCard()
      ],
    ));
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _authInstance = FirebaseAuth.instance;
  var isLoading = false;
  var isLogin = true;

  void _changeLoginStatus() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void authentication(bool validateForm, String userEmail, String userPassword,
      String userName, File userImage) async {
    if (!validateForm) {
      return;
    }
    changeLoading();
    try {
      if (isLogin)
        await _authInstance.signInWithEmailAndPassword(
            email: userEmail, password: userPassword);
      else {
        final authUser = await _authInstance.createUserWithEmailAndPassword(
            email: userEmail, password: userPassword);
        final user = UserInformation(
            userName,
            userEmail,
            authUser.user.uid,
            await _uploadUserImage(authUser.user.uid, userImage),
            "${userEmail.split("@")[0].trim()}@${authUser.user.uid.substring(0, 6)}.sarhah");
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .set(user.toMap());
      }
    } on FirebaseAuthException catch (err) {
      _showErrorDialog(err.message);
    }
  }

  Future<String> _uploadUserImage(String uid, File userImage) async {
    if (userImage == null) return "";
    final ref = FirebaseStorage.instance.ref().child(USERS).child("$uid.jpg");
    await ref.putFile(userImage).onComplete;
    final url = await ref.getDownloadURL();
    return url;
  }

  void _showErrorDialog(error) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(error),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
              changeLoading();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height:  deviceSize.height * .85,
      width: deviceSize.width * .80,
      alignment: Alignment.center,
      child: Card(
        elevation: 6,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: AuthFormWidget(
              authentication,
              isLogin,
              isLoading,
              _changeLoginStatus,
            )),
      ),
    );
  }
}
