import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sarahah_chat/models/UserInformation.dart';
import 'package:sarahah_chat/ui/widgets/PickImageWidget.dart';
import 'package:sarahah_chat/ui/widgets/TextFormWidget.dart';

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
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _authInstance = FirebaseAuth.instance;
  var isLoading = false;
  var expand = false;
  var isLogin = true;
  File userImage;

  void changeCardHeight(bool changeExpand) {
    if (expand != changeExpand)
      setState(() {
        this.expand = changeExpand;
      });
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void authentication() async {
    if (!_form.currentState.validate()) {
      changeCardHeight(true);
      return;
    }
    changeCardHeight(false);
    changeLoading();
    try {
      if (isLogin)
        await _authInstance.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      else {
        final authUser = await _authInstance.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        final user = UserInformation(
            _userNameController.text,
            _emailController.text,
            authUser.user.uid,
            await _uploadUserImage(authUser.user.uid),
            "${_userNameController.text}@${authUser.user.uid.substring(0, 6)}.sarhah");
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .set(user.toMap());
      }
    } catch (err) {
      _showErrorDialog();
    }
  }
  Future<String> _uploadUserImage(String uid) async{
    if(userImage == null)
      return "";

    final ref = FirebaseStorage.instance.ref().child("users").child("$uid.jpg");
    await ref.putFile(userImage).onComplete;
    final url = await ref.getDownloadURL();
    return url;
  }

  void pickedImage(File image){
    userImage = image;
  }

  void _changeLoginStatus() {
    setState(() {
      isLogin = !isLogin;
    });
    changeCardHeight(true);
  }



  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text("Please try again."),
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
      height: expand ? deviceSize.height * .85 : 400,
      width: deviceSize.width * .80,
      alignment: Alignment.center,
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (!isLogin) PickImageWidget(pickedImage),
                  TextFormWidget(
                    "Email:",
                    _emailController,
                    TextInputAction.next,
                    false,
                    (val) {
                      if (val.isEmpty || !val.contains("@"))
                        return "Add a valid email.";
                      return null;
                    },
                  ),
                  if (!isLogin)
                    TextFormWidget(
                      "Username:",
                      _userNameController,
                      TextInputAction.next,
                      false,
                      (val) {
                        if (val.isEmpty) return "Add a valid username.";
                        return null;
                      },
                    ),
                  TextFormWidget(
                    "Password:",
                    _passwordController,
                    TextInputAction.next,
                    true,
                    (val) {
                      if (val.isEmpty)
                        return "Add a valid password.";
                      else if (val.length < 6)
                        return "Password must at least 6 characters";
                      return null;
                    },
                  ),
                  if (!isLogin)
                    TextFormWidget(
                      "Confirm Password:",
                      null,
                      TextInputAction.done,
                      true,
                      (val) {
                        if (val != _passwordController.text)
                          return "Passwords do not match!";
                        return null;
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          child: Text(
                            isLogin ? "Sign in" : "Sign up",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onPressed: authentication,
                        ),
                  FlatButton(
                    child: Text(
                      "${isLogin ? "SIGN UP" : "LOGIN"} INSTEAD.",
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _changeLoginStatus,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
