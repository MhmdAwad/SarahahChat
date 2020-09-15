import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageWidget extends StatefulWidget {
  final Function pickedImage;

  PickImageWidget(this.pickedImage);

  @override
  _PickImageWidgetState createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  File userImage;

  void pickImage(ImageSource selectedSource) async {
    final pickedImage = await ImagePicker.platform.pickImage(
      source: selectedSource,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) return;
    setState(() {
      userImage = File(pickedImage.path);
    });
    widget.pickedImage(userImage);
  }

  void chooseImage() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Pick Image"),
              actions: [
                FlatButton(
                  child: Text("From Camera"),
                  onPressed: () {
                    pickImage(ImageSource.camera);
                    Navigator.of(ctx).pop();
                  },
                ),
                FlatButton(
                  child: Text("From Gallery"),
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey,
          backgroundImage: userImage == null
              ? null
              : FileImage(
                  userImage,
                ),
        ),
          Positioned(
            right: 4,
            bottom: 4,
            child: Icon(Icons.add_a_photo, color: Colors.black87,),
          )
      ]),
      onTap: chooseImage,
    );
  }
}
