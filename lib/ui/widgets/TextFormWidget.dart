import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Function validate;
  final TextInputAction action;
  final bool                    obscureText;


  TextFormWidget(this.labelText, this.controller, this.action,this.obscureText,this.validate);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      textInputAction: action,
      obscureText: obscureText,
      validator: validate,
    );
  }
}
