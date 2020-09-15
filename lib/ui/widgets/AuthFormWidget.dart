import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sarahah_chat/ui/widgets/PickImageWidget.dart';
import 'package:sarahah_chat/ui/widgets/TextFormWidget.dart';

class AuthFormWidget extends StatefulWidget {
  final Function(
    bool validateForm,
    String userEmail,
    String userPassword,
    String userName,
    File userImage,
  ) authentication;
  final bool isLogin;
  final bool isLoading;
  final Function _changeLoginStatus;

  AuthFormWidget(this.authentication, this.isLogin, this.isLoading,
      this._changeLoginStatus);

  @override
  _AuthFormWidgetState createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();
  File userImage;

  void pickedImage(File image) {
    userImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (!widget.isLogin) PickImageWidget(pickedImage),
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
            if (!widget.isLogin)
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
            if (!widget.isLogin)
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
            widget.isLoading
                ? CircularProgressIndicator()
                : RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    child: Text(
                      widget.isLogin ? "Sign in" : "Sign up",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    onPressed: () => widget.authentication(
                        _form.currentState.validate(),
                        _emailController.text,
                        _passwordController.text,
                        _userNameController.text,
                        userImage),
                  ),
            FlatButton(
              child: Text(
                "${widget.isLogin ? "SIGN UP" : "LOGIN"} INSTEAD.",
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textColor: Theme.of(context).primaryColor,
              onPressed: widget._changeLoginStatus,
            ),
          ],
        ),
      ),
    );
  }
}
