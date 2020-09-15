import 'package:flutter/material.dart';
import 'package:sarahah_chat/utils/FindStatus.dart';

class FoundUserWidget extends StatelessWidget {
  final String foundUserImage;
  final String foundUsername;
  final Function createChat;
  final Function changeStatus;

  FoundUserWidget(this.foundUserImage, this.foundUsername, this.createChat,
      this.changeStatus);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: foundUserImage.startsWith("http")
                ? NetworkImage(foundUserImage)
                : AssetImage(
                    "assets/images/person.png",
                  ),
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
            onPressed: () => changeStatus(FindStatus.FAILED),
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
    );
  }
}
